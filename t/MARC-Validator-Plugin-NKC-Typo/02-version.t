use strict;
use warnings;

use MARC::Validator::Plugin::NKC::Typo;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($MARC::Validator::Plugin::NKC::Typo::VERSION, 0.05, 'Version.');
