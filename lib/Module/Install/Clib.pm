package Module::Install::Clib;
use strict;
use warnings;
our $VERSION = '0.04';
use 5.008_001;
use base qw(Module::Install::Base);
use Config;
use File::Spec;

sub clib_header {
    my ($self, $filename) = @_;
    (my $distname = $self->name) =~ s/Clib-//;

    my $blib_dir = File::Spec->catfile('$(INST_ARCHLIB)', 'auto', 'Clib', 'include', $distname);
    my $blib_dst = File::Spec->catdir($blib_dir, $filename);
$self->postamble(<<"END_MAKEFILE");
config ::
\t\t\$(NOECHO) \$(ECHO) copy $filename to $blib_dst
\t\t\$(NOECHO) \$(MKPATH) $blib_dir
\t\t\$(NOECHO) \$(CP) $filename $blib_dst

END_MAKEFILE
}

sub clib_library {
    my ($self, $filename) = @_;
    (my $distname = $self->name) =~ s/Clib-//;

    my $blib_dir = File::Spec->catdir('$(INST_ARCHLIB)', 'auto', 'Clib', 'lib');
    my $blib_dst = File::Spec->catfile($blib_dir, $filename);
$self->postamble(<<"END_MAKEFILE");
config ::
\t\t\$(NOECHO) \$(ECHO) copy $filename to $blib_dst
\t\t\$(NOECHO) \$(MKPATH) $blib_dir
\t\t\$(NOECHO) \$(CP) $filename $blib_dst

END_MAKEFILE
}

sub clib_setup {
    my ($self) = @_;
    my %uniq;
    my @dirs = grep { $uniq{$_}++ == 0 } map { File::Spec->catfile($_, qw/auto Clib/) } grep /$Config{archname}/, @INC;
    my @libs = grep { -d $_ } map { File::Spec->catfile($_, 'lib') }     @dirs;
    my @incs = grep { -d $_ } map { File::Spec->catfile($_, 'include') } @dirs;

    my $incs = $self->makemaker_args->{INC} || '';
    $self->makemaker_args->{INC} = "-I\$(INST_ARCHLIB)/auto/Clib/include/ " . join(" ", map { "-I$_" } @incs) . ' ' . $incs;

    my $libs = $self->makemaker_args->{LIBS} || '';
    $self->makemaker_args->{LIBS} = join(" ", map { "-L$_" } @libs) . ' ' . $libs;
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
