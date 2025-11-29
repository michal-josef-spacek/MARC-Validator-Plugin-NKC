package MARC::Validator::Plugin::NKC::Sigla;

use base qw(MARC::Validator::Abstract);
use strict;
use warnings;

use English;
use Error::Pure::Utils qw(err_get);
use File::Share ':all';
use MARC::Leader;
use MARC::Validator::Utils qw(add_error);
use Perl6::Slurp qw(slurp);

our $VERSION = 0.02;

sub name {
	my $self = shift;

	return 'sigla';
}

sub process {
	my ($self, $marc_record) = @_;

	my $struct_hr = $self->{'struct'}->{'checks'};

	my $error_id = $self->{'cb_error_id'}->($marc_record);

	my $leader_string = $marc_record->leader;
	my $leader = eval {
		MARC::Leader->new(
			'verbose' => $self->{'verbose'},
		)->parse($leader_string);
	};
	if ($EVAL_ERROR) {
		my @errors = err_get(1);
		$struct_hr->{'not_valid'}->{$error_id} = [];
		foreach my $error (@errors) {
			my %err_params = @{$error->{'msg'}}[1 .. $#{$error->{'msg'}}];
			# TODO Rewrite to add_error?
			push @{$struct_hr->{'not_valid'}->{$error_id}}, {
				'error' => $error->{'msg'}->[0],
				'params' => \%err_params,
			};
		}
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
				add_error($error_id, $struct_hr, {
					'error' => 'Bad agency in 040'.$subfield.' field.',
					'params' => {
						'value' => $field_040_sub,
					},
				});
			} elsif (! exists $self->{'_agencies'}->{$field_040_sub}
				&& ! exists $self->{'_siglas'}->{$field_040_sub}) {

				add_error($error_id, $struct_hr, {
					'error' => 'Bad sigla in 040'.$subfield.' field.',
					'params' => {
						'value' => $field_040_sub,
					},
				});
			}
		}
	}

	return;
}

sub _init {
	my $self = shift;

	$self->{'struct'}->{'module_name'} = __PACKAGE__;
	$self->{'struct'}->{'module_version'} = $VERSION;

	$self->{'struct'}->{'checks'}->{'not_valid'} = {};

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

1;

__END__
