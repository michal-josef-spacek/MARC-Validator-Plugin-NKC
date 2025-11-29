use lib '.';
use strict;
use warnings;

use inc::Module::Install;

# Definition.
abstract 'MARC validator plugins for the Czech National Library.';
author 'Michal Josef Spacek <skim@cpan.org>';
author_requires 'English' => 0;
author_requires 'File::Object' => 0.05;
author_requires 'Test::More' => 0;
author_requires 'Test::NoWarnings' => 0;
author_requires 'Test::Pod' => 0;
author_requires 'Test::Pod::Coverage' => 0;
install_share 'share';
license 'bsd';
name 'MARC-Validator-Plugin-NKC';
perl_version 5.006002;
readme_from 'NKC.pod';
recursive_author_tests('xt');
requires 'English' => 0;
requires 'Error::Pure::Utils' => 0;
requires 'File::Share' => 0;
requires 'MARC::Leader' => 0.04;
requires 'MARC::Leader::Utils' => 0;
requires 'MARC::Validator::Abstract' => 0;
requires 'Perl6::Slurp' => 0;
resources 'bugtracker' => 'https://github.com/michal-josef-spacek/MARC-Validator-Plugin-NKC/issues',
resources 'homepage' => 'https://github.com/michal-josef-spacek/MARC-Validator-Plugin-NKC';
resources 'repository' => 'git://github.com/michal-josef-spacek/MARC-Validator-Plugin-NKC';
test_requires 'Test::More' => 0;
test_requires 'Test::NoWarnings' => 0;
tests_recursive;
version '0.02';

# Run.
WriteAll();
