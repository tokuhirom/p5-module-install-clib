use t::Utils;
use Test::More;
use strict;
use warnings;

setup;
cleanup 'inc', 'blib', 'inst';

my $x = `$^X -I ../../lib Makefile.PL`;
for my $key (qw/INC LIBS/) {
    ok $x =~ /$key:(.+)\n/, $key;
    my @stuff = split /\s+/, $1;
    my %uniq;
    map { $uniq{$_}++ } @stuff;
    is scalar(grep { $uniq{$_} > 1 } keys %uniq), 0, 'whole keys are uniq';
}

done_testing;

