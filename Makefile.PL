use inc::Module::Install;
name 'Module-Install-Clib';
all_from 'lib/Module/Install/Clib.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
