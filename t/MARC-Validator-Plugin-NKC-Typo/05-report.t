use strict;
use warnings;

use File::Object;
use MARC::File::XML (BinaryEncoding => 'utf8', RecordFormat => 'MARC21');
use MARC::Validator::Plugin::NKC::Typo;
use Test::More 'tests' => 41;
use Test::NoWarnings;
use Unicode::UTF8 qw(decode_utf8);

# Data dir.
my $data_dir = File::Object->new->up->dir('data');

# Test.
my $obj = MARC::Validator::Plugin::NKC::Typo->new;
my $ret = $obj->report;
isa_ok($ret, 'Data::MARC::Validator::Report::Plugin');
is(scalar @{$ret->plugin_errors}, 0, 'No errors without init.');

# Test.
$obj = MARC::Validator::Plugin::NKC::Typo->new;
$obj->init;
$ret = $obj->report;
isa_ok($ret, 'Data::MARC::Validator::Report::Plugin');
is(scalar @{$ret->plugin_errors}, 0, 'No errors with init, without process.');

# Test.
$obj = MARC::Validator::Plugin::NKC::Typo->new(
	'record_id_def' => '015a',
);
$obj->init;
my $marc_record = MARC::File::XML->in($data_dir->file('cnb000031508-260b_ger_typo.xml')->s)->next;
$obj->process($marc_record);
$ret = $obj->report;
isa_ok($ret, 'Data::MARC::Validator::Report::Plugin');
ok(defined $ret->module_name, 'Module name is defined.');
ok(defined $ret->version, 'Version is defined.');
is($ret->name, 'typo', 'Get name (typo).');
my $errors = $ret->plugin_errors;
is($errors->[0]->record_id, 'cnb000031508', 'Get record id (cnb000031508).');
is($errors->[0]->errors->[0]->error, "Typo in 260b field.",
	"Typo in 260b field.");
is($errors->[0]->errors->[0]->params->{'value'}, decode_utf8("Tschechoslovakischee Komitee für europäische Sicherheit :"),
	'Get error parameter (value => Tschechoslovakischee Komitee für europäische Sicherheit :).');
is($errors->[0]->errors->[0]->params->{'expected_value'}, 'Tschechoslowakische',
	'Get error parameter (expected_value => Tschechoslowakische).');
is($errors->[0]->errors->[0]->params->{'typo_value'}, 'Tschechoslovakischee',
	'Get error parameter (typo_value => Tschechoslovakischee).');

# Test.
$obj = MARC::Validator::Plugin::NKC::Typo->new(
	'record_id_def' => '015a',
);
$obj->init;
$marc_record = MARC::File::XML->in($data_dir->file('cnb000121823-260b_cze_typo.xml')->s)->next;
$obj->process($marc_record);
$ret = $obj->report;
isa_ok($ret, 'Data::MARC::Validator::Report::Plugin');
ok(defined $ret->module_name, 'Module name is defined.');
ok(defined $ret->version, 'Version is defined.');
is($ret->name, 'typo', 'Get name (typo).');
$errors = $ret->plugin_errors;
is($errors->[0]->record_id, 'cnb000121823', 'Get record id (cnb000121823).');
is($errors->[0]->errors->[0]->error, "Typo in 260b field.",
	"Typo in 260b field.");
is($errors->[0]->errors->[0]->params->{'value'}, decode_utf8("SStátní pedagogické nakladatelství,"),
	'Get error parameter (value => SStátní pedagogické nakladatelství,).');
is($errors->[0]->errors->[0]->params->{'expected_value'}, decode_utf8('Státní'),
	'Get error parameter (expected_value => Státní).');
is($errors->[0]->errors->[0]->params->{'typo_value'}, decode_utf8('SStátní'),
	'Get error parameter (typo_value => SStátní).');

# Test.
$obj = MARC::Validator::Plugin::NKC::Typo->new(
	'record_id_def' => '015a',
);
$obj->init;
$marc_record = MARC::File::XML->in($data_dir->file('cnb001235929-260b_fre_typo.xml')->s)->next;
$obj->process($marc_record);
$ret = $obj->report;
isa_ok($ret, 'Data::MARC::Validator::Report::Plugin');
ok(defined $ret->module_name, 'Module name is defined.');
ok(defined $ret->version, 'Version is defined.');
is($ret->name, 'typo', 'Get name (typo).');
$errors = $ret->plugin_errors;
is($errors->[0]->record_id, 'cnb001235929', 'Get record id (cnb001235929).');
is($errors->[0]->errors->[0]->error, "Typo in 260b field.",
	"Typo in 260b field.");
is($errors->[0]->errors->[0]->params->{'value'}, 'Glassexpor,',
	'Get error parameter (value => Glassexpor,).');
is($errors->[0]->errors->[0]->params->{'expected_value'}, 'Glassexport',
	'Get error parameter (expected_value => Glassexport).');
is($errors->[0]->errors->[0]->params->{'typo_value'}, 'Glassexpor',
	'Get error parameter (typo_value => Glassexpor).');

# Test.
$obj = MARC::Validator::Plugin::NKC::Typo->new(
	'record_id_def' => '015a',
);
$obj->init;
$marc_record = MARC::File::XML->in($data_dir->file('cnb001503870-260b_eng_typo.xml')->s)->next;
$obj->process($marc_record);
$ret = $obj->report;
isa_ok($ret, 'Data::MARC::Validator::Report::Plugin');
ok(defined $ret->module_name, 'Module name is defined.');
ok(defined $ret->version, 'Version is defined.');
is($ret->name, 'typo', 'Get name (typo).');
$errors = $ret->plugin_errors;
is($errors->[0]->record_id, 'cnb001503870', 'Get record id (cnb001503870).');
is($errors->[0]->errors->[0]->error, "Typo in 260b field.",
	"Typo in 260b field.");
is($errors->[0]->errors->[0]->params->{'value'}, decode_utf8('House of Engeeniring of ČVTS,'),
	'Get error parameter (value => House of Engeeniring of ČVTS,).');
is($errors->[0]->errors->[0]->params->{'expected_value'}, 'Engineering',
	'Get error parameter (expected_value => Engineering).');
is($errors->[0]->errors->[0]->params->{'typo_value'}, 'Engeeniring',
	'Get error parameter (typo_value => Engeeniring).');
