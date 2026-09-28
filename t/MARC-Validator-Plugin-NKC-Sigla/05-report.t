use strict;
use warnings;

use File::Object;
use MARC::File::XML (BinaryEncoding => 'utf8', RecordFormat => 'MARC21');
use MARC::Validator::Plugin::NKC::Sigla;
use Test::More 'tests' => 26;
use Test::NoWarnings;

# Data dir.
my $data_dir = File::Object->new->up->dir('data');

# Test.
my $obj = MARC::Validator::Plugin::NKC::Sigla->new;
my $ret = $obj->report;
isa_ok($ret, 'Data::MARC::Validator::Report::Plugin');
is(scalar @{$ret->plugin_errors}, 0, 'No errors without init.');

# Test.
$obj = MARC::Validator::Plugin::NKC::Sigla->new;
$obj->init;
$ret = $obj->report;
isa_ok($ret, 'Data::MARC::Validator::Report::Plugin');
is(scalar @{$ret->plugin_errors}, 0, 'No errors with init, without process.');

# Test.
$obj = MARC::Validator::Plugin::NKC::Sigla->new(
	'record_id_def' => '015a',
);
$obj->init;
my $marc_record = MARC::File::XML->in($data_dir->file('cnb000773818-040c-bad_agency.xml')->s)->next;
$obj->process($marc_record);
$ret = $obj->report;
isa_ok($ret, 'Data::MARC::Validator::Report::Plugin');
ok(defined $ret->module_name, 'Module name is defined.');
ok(defined $ret->version, 'Version is defined.');
is($ret->name, 'sigla', 'Get name (sigla).');
my $errors = $ret->plugin_errors;
is($errors->[0]->record_id, 'cnb000773818', 'Get record id (cnb000773818).');
is($errors->[0]->errors->[0]->error, "Bad agency in 040c field.",
	"Bad agency in 040c field.");
is($errors->[0]->errors->[0]->params->{'value'}, 'rda',
	'Get error parameter (value => rda).');

# Test.
$obj = MARC::Validator::Plugin::NKC::Sigla->new(
	'record_id_def' => '015a',
);
$obj->init;
$marc_record = MARC::File::XML->in($data_dir->file('cnb001250009-040a-bad_agency.xml')->s)->next;
$obj->process($marc_record);
$ret = $obj->report;
isa_ok($ret, 'Data::MARC::Validator::Report::Plugin');
ok(defined $ret->module_name, 'Module name is defined.');
ok(defined $ret->version, 'Version is defined.');
is($ret->name, 'sigla', 'Get name (sigla).');
$errors = $ret->plugin_errors;
is($errors->[0]->record_id, 'cnb001250009', 'Get record id (cnb001250009).');
is($errors->[0]->errors->[0]->error, "Bad agency in 040a field.",
	"Bad agency in 040a field.");
is($errors->[0]->errors->[0]->params->{'value'}, 'cze',
	'Get error parameter (value => cze).');

# Test.
$obj = MARC::Validator::Plugin::NKC::Sigla->new(
	'record_id_def' => '015a',
);
$obj->init;
$marc_record = MARC::File::XML->in($data_dir->file('cnb003682127-040d-bad_agency.xml')->s)->next;
$obj->process($marc_record);
$ret = $obj->report;
isa_ok($ret, 'Data::MARC::Validator::Report::Plugin');
ok(defined $ret->module_name, 'Module name is defined.');
ok(defined $ret->version, 'Version is defined.');
is($ret->name, 'sigla', 'Get name (sigla).');
$errors = $ret->plugin_errors;
is($errors->[0]->record_id, 'cnb003682127', 'Get record id (cnb003682127).');
is($errors->[0]->errors->[0]->error, "Bad agency in 040d field.",
	"Bad agency in 040d field.");
is($errors->[0]->errors->[0]->params->{'value'}, 'rda',
	'Get error parameter (value => rda).');
