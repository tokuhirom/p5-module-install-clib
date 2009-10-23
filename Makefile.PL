use inc::Module::Install;
name 'Module-Install-Clib';
all_from 'lib/Module/Install/Clib.pm';

requires 'Module::Install';
requires 'Module::Install::XSUtil';

tests 't/*.t t/*/*.t t/*/*/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
