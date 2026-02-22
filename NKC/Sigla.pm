package MARC::Validator::Plugin::NKC::Sigla;

use base qw(MARC::Validator::Abstract);
use strict;
use warnings;

use Data::MARC::Validator::Report::Error 0.02;
use Data::MARC::Validator::Report::Plugin::Errors 0.02;
use English;
use Error::Pure::Utils qw(err_get);
use File::Share ':all';
use MARC::Leader;
use Perl6::Slurp qw(slurp);

our $VERSION = 0.03;

sub module_name {
	my $self = shift;

	return __PACKAGE__;
}

sub name {
	my $self = shift;

	return 'sigla';
}

sub process {
	my ($self, $marc_record) = @_;

	my $struct_hr = $self->{'struct'}->{'checks'};

	my $record_id = $self->{'cb_record_id'}->($marc_record);
	my @record_errors;

	my $leader_string = $marc_record->leader;
	my $leader = eval {
		MARC::Leader->new(
			'verbose' => $self->{'verbose'},
		)->parse($leader_string);
	};
	if ($EVAL_ERROR) {
		my @errors = err_get(1);
		foreach my $error (@errors) {
			my %err_params = @{$error->{'msg'}}[1 .. $#{$error->{'msg'}}];
			push @record_errors, Data::MARC::Validator::Report::Error->new(
				'error' => $error->{'msg'}->[0],
				'params' => \%err_params,
			);
		}
		$self->_process_errors($record_id, @record_errors);
		return;
	}

	my $field_040 = $marc_record->field('040');
	if (! defined $field_040) {
		return;
	}
	foreach my $subfield (qw(a c d)) {
		my $field_040_sub = $field_040->subfield($subfield);
		if (defined $field_040_sub) {
			if (exists $self->{'_bad_agencies'}->{$field_040_sub}) {
				push @record_errors, Data::MARC::Validator::Report::Error->new(
					'error' => 'Bad agency in 040'.$subfield.' field.',
					'params' => {
						'value' => $field_040_sub,
					},
				);
			} elsif (! exists $self->{'_agencies'}->{$field_040_sub}
				&& ! exists $self->{'_siglas'}->{$field_040_sub}) {

				push @record_errors, Data::MARC::Validator::Report::Error->new(
					'error' => 'Bad sigla in 040'.$subfield.' field.',
					'params' => {
						'value' => $field_040_sub,
					},
				);
			}
		}
	}

	$self->_process_errors($record_id, @record_errors);

	return;
}

sub version {
	my $self = shift;

	return $VERSION;
}

sub _init {
	my $self = shift;

	# Load agencies.
	my $agencies_file = dist_file('MARC-Validator-Plugin-NKC', 'AGENCIES');
	my %agencies = map { $_ => 1 } slurp($agencies_file, { 'chomp' => 1 });
	$self->{'_agencies'} = \%agencies;

	# Load bad agencies.
	my $bad_agencies_file = dist_file('MARC-Validator-Plugin-NKC', 'BAD_AGENCIES');
	my %bad_agencies = map { $_ => 1 } slurp($bad_agencies_file, { 'chomp' => 1 });
	$self->{'_bad_agencies'} = \%bad_agencies;

	# Load siglas.
	my $siglas_file = dist_file('MARC-Validator-Plugin-NKC', 'SIGLAS');
	my %siglas = map { $_ => 1 } slurp($siglas_file, { 'chomp' => 1 });
	$self->{'_siglas'} = \%siglas;

	return;
}

sub _process_errors {
	my ($self, $record_id, @record_errors) = @_;

	if (@record_errors) {
		push @{$self->{'errors'}}, Data::MARC::Validator::Report::Plugin::Errors->new(
			'errors' => \@record_errors,
			# TODO process
			'filters' => [],
			'record_id' => $record_id,
		);
	}

	return;
}

1;

__END__
