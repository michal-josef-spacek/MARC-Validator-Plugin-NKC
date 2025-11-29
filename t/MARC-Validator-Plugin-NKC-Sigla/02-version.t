use strict;
use warnings;

use MARC::Validator::Plugin::NKC::Sigla;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($MARC::Validator::Plugin::NKC::Sigla::VERSION, 0.01, 'Version.');
