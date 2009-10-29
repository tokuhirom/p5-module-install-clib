use t::Utils;
use Test::More;
use strict;
use warnings;

setup;
cleanup 'inc', 'blib', 'inst';

open my $fh, '>', 'bar.so' or die $!;
print $fh "this is bar.so";
close $fh;

run_makefile_pl;
run_make();
ok -f 'blib/arch/auto/Clib/include/test/foo.h';
ok -f 'blib/arch/auto/Clib/lib/bar.so';
ok -f 'blib/lib/Foo.pm';

ok !-d 'inst';
run_make('install');
ok -f './inst/auto/Clib/include/test/foo.h';
is slurp('./inst/auto/Clib/include/test/foo.h'), "THIS IS TEST THING(foo.h)\n";
is slurp('./inst/auto/Clib/lib/bar.so'), 'this is bar.so';
is slurp('./inst/Foo.pm'), "package Foo;\n1;\n";
done_testing;

sub slurp {
    my $fname = shift;
    open my $fh, '<', $fname or die $!;
    do { local $/; <$fh> };
}
