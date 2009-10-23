use t::Utils;
use Test::More;
use strict;
use warnings;

setup;

open my $fh, '>', 'bar.so' or die $!;
print $fh "this is bar.so";
close $fh;

run_makefile_pl;
run_make('install');
is slurp('./inst/auto/Clib/include/test/foo.h'), "THIS IS TEST THING(foo.h)\n";
is slurp('./inst/auto/Clib/lib/bar.so'), 'this is bar.so';
done_testing;

sub slurp {
    my $fname = shift;
    open my $fh, '<', $fname or die $!;
    do { local $/; <$fh> };
}
