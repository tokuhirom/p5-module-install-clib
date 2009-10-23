use inc::Module::Install;
license 'perl';
name 'test';

clib_header  'foo.h';
clib_library 'bar.so';

makemaker_args(
    INSTALLARCHLIB => './inst/',
);

WriteAll;
