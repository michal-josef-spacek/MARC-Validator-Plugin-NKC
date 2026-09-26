package MARC::Validator::Plugin::NKC::Typo;

use base qw(MARC::Validator::Abstract);
use strict;
use utf8;
use warnings;

use Data::MARC::Validator::Report::Error 0.02;
use Data::MARC::Validator::Report::Plugin::Errors 0.02;
use English;
use Error::Pure::Utils qw(clean);
use MARC::Field008;
use MARC::Leader;
use Readonly;

Readonly::Hash our %FIELD_PUBLISHER => (
	'cze' => {
		'Aarmáda' => 'Armáda',
		'akademi' => 'akademie',
		'architektruy' => 'architektury',
		'českou literatura' => 'českou literaturu',
		'Česloslovenská' => 'Československá',
		'Československý ústavu' => 'Československý ústav',
		'eonomických' => 'ekonomických',
		'hospodárského' => 'hospodářského',
		'imformace' => 'informace',
		'Králvé' => 'Králové',
		'modelářské klubu' => 'modelářského klubu',
		'numismatiská' => 'numismatická',
		'odddělením' => 'oddělením',
		'odddělení' => 'oddělení',
		'oddělelní' => 'oddělení',
		'Poištovna' => 'Pojišťovna',
		'pojisťovna' => 'pojišťovna',
		'polititická' => 'politická',
		'potapěčského' => 'potápěčského',
		'rostliné' => 'rostlinné',
		'Rrůmyslové' => 'Průmyslové',
		'socialního' => 'sociálního',
		'Socistického' => 'Socialistického',
		'SPN5' => 'SPN',
		'spleč.' => 'společ.',
		'společnosti pro šíření' => 'společnost pro šíření',
		'společnsti' => 'společnosti',
		'SStátní' => 'Státní',
		'stání pojišťovna' => 'státní pojišťovna',
		'Státtní' => 'Státní',
		'studíí' => 'studií',
		'škoslkých' => 'školských',
		'Ústavpro' => 'Ústav pro',
		'věděcká' => 'vědecká',
		'všdecká' => 'vědecká',
		'vydavavatelství' => 'vydavatelství',
		'Vydavavatelství' => 'Vydavatelství',
		'vědeckotechnikých' => 'vědeckotechnických',
		'zemědělsské' => 'zemědělské',
		'zeměďelský' => 'zemědělský',
		'zaměstannaců' => 'zaměstnanců',
		'zemmědělská' => 'zemědělská',
	},
	'eng' => {
		'Engeeniring' => 'Engineering',
	},
	'fre' => {
		'Glassexpor' => 'Glassexport',
	},
	'ger' => {
		'Handelkammer' => 'Handelskammer',
		'Informationenn' => 'Informationen',
		'Kommunistischischen' => 'Kommunistischen',
		'Tschechoslovakischee' => 'Tschechoslowakische',
		'Wissemschaften' => 'Wissenschaften',
	},
	'slo' => {
		'SVOZzväzu' => 'SVOZ zväzu',
		'hodobné' => 'hudobné',
	},
	'spa' => {
		'iInternacional' => 'Internacional',
	},
);

our $VERSION = 0.05;

sub module_name {
	my $self = shift;

	return __PACKAGE__;
}

sub name {
	my $self = shift;

	return 'typo';
}

sub process {
	my ($self, $marc_record) = @_;

	my $record_id = $self->{'cb_record_id'}->($marc_record);
	my @record_errors;

	my $leader_string = $marc_record->leader;
	my $leader = eval {
		MARC::Leader->new(
			'verbose' => $self->{'verbose'},
		)->parse($leader_string);
	};
	if ($EVAL_ERROR) {
		# Error in leader, not validate.
		clean();
		return;
	}

	my $field_008_obj = $marc_record->field('008');
	if (! defined $field_008_obj) {
		return;
	}
	my $field_008_string = $field_008_obj->as_string;
	my $field_008 = eval {
		MARC::Field008->new(
			'leader' => $leader,
			'verbose' => $self->{'verbose'},
		)->parse($field_008_string);
	};
	if ($EVAL_ERROR) {
		clean();
		return;
	}

	my $lang = $field_008->language;
	if ($lang eq '   ' || $lang eq '|||') {
		return;
	}

	foreach my $field_subfield ('260b', '264b', '928a') {
		my ($field, $subfield) = $field_subfield =~ m/^(\d+)(.*)$/ms;
		my $value = $marc_record->subfield($field, $subfield);
		if (defined $value && exists $FIELD_PUBLISHER{$lang}) {
			foreach my $exp_value (keys %{$FIELD_PUBLISHER{$lang}}) {
				if ($value =~ m/$exp_value(?:\s|,|\.|;|$)/ms) {
					push @record_errors, Data::MARC::Validator::Report::Error->new(
						'error' => "Typo in $field$subfield field.",
						'params' => {
							'value' => $value,
							'typo_value' => $exp_value,
							'expected_value' => $FIELD_PUBLISHER{$lang}->{$exp_value},
						},
					);
				}
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

sub _process_errors {
	my ($self, $record_id, @record_errors) = @_;

	if (@record_errors) {
		push @{$self->{'errors'}}, Data::MARC::Validator::Report::Plugin::Errors->new(
			'errors' => \@record_errors,
			'filters' => $self->{'filters'},
			'record_id' => $record_id,
		);
	}

	return;
}

1;

__END__
