package Module::Install::Clib;
use strict;
use warnings;
our $VERSION = '0.01';
use 5.008_001;
use base qw(Module::Install::Base);
use Config;
use File::Spec;

my $installer = q{$(NOECHO) $(ABSPERL) -e 'use File::Copy; use File::Path qw/mkpath/; use File::Basename; mkpath(dirname($$ARGV[1])); File::Copy::copy($$ARGV[0], $$ARGV[1]) or die qq[Copy failed: $$!]'};

sub clib_header {
    my ($self, $filename) = @_;
    (my $distname = $self->name) =~ s/Clib-//;

    my $dst = File::Spec->catfile('$(INSTALLARCHLIB)', 'auto', 'Clib', 'include', $distname, $filename);
    $self->postamble(<<"END_MAKEFILE");
config ::
\t\t\$(ECHO) Installing $dst
\t\t$installer "$filename" $dst

END_MAKEFILE
}

sub clib_library {
    my ($self, $filename) = @_;
    (my $distname = $self->name) =~ s/Clib-//;

    my $dst = File::Spec->catfile('$(INSTALLARCHLIB)', 'auto', 'Clib', 'lib', $filename);
    $self->postamble(<<"END_MAKEFILE");
config ::
\t\t\$(ECHO) Installing $dst
\t\t$installer "$filename" $dst

END_MAKEFILE
}

sub clib_setup {
    my ($self) = @_;
    my @dirs = map { File::Spec->catfile($_, qw/auto Clib/) } grep /$Config{archname}/, @INC;
    my @libs = grep { -d $_ } map { File::Spec->catfile($_, 'lib') }     @dirs;
    my @incs = grep { -d $_ } map { File::Spec->catfile($_, 'include') } @dirs;
    $self->cc_append_to_inc(@incs);
    $self->cc_append_to_libs(@libs);
}

1;
__END__

=head1 NAME

Module::Install::Clib -

=head1 SYNOPSIS

    # in your Clib-* package
    use inc::Module::Install;
    clib_header('nanotap.h');
    clib_library('nanotap');

    # in your xs package
    use inc::Module::Install;
    clib_setup(); # sets library path, include path
    MakeMakerArgs(
        LIBS => '-lnanotap',
    );

=head1 DESCRIPTION

Module::Install::Clib is installer for L<Clib>.
You can install C libraries to $INSTALLARCHLIB/auto/Clib/.

=head1 WARNINGS

THIS IS EARLY BETA RELEASE.API MAY CHANGE.

=head1 FUNCTIONS

=over 4

=item clib_header($header_file_name);

copy $header_file_name to $INSTALLARCHLIB/auto/Clib/include/$distname/$header_file_name.

=item clib_library($library_file_name)

copy $library_file_name to $INSTALLARCHLIB/auto/Clib/lib/$library_file_name.

=item clib_setup()

setup environment for Clib.

=back

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom  slkjfd gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
