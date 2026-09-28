use strict;
use warnings;

use MARC::Validator::Plugin::NKC::Sigla;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
my $obj = MARC::Validator::Plugin::NKC::Sigla->new;
is($obj->name, 'sigla', 'Get name of plugin (sigla).');
