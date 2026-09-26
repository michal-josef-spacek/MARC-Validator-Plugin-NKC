use strict;
use warnings;

use MARC::Validator::Plugin::NKC::Typo;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
my $obj = MARC::Validator::Plugin::NKC::Typo->new;
is($obj->name, 'typo', 'Get name of plugin (typo).');
