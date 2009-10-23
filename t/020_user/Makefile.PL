use inc::Module::Install;
license 'perl';
name 'test';

clib_setup;

print "LIBS:".makemaker_args()->{LIBS}, "\n";
print "INC:".makemaker_args()->{INC}, "\n";

