package Scope::Ban;
use 5.008_001;
use strict;
use warnings;

our $VERSION = '0.01';

sub new {
    my($class, @pkgs) = @_;
    my $self = bless {
        packages  => \@pkgs,
        originals => { },
    }, $class;
    foreach my $pkg(@pkgs) {
        $self->disable($pkg);
    }
    return $self;
}

sub packages {
    my($self) = @_;
    return @{$self->{packages}};
}

sub DESTROY {
    my($self) = @_;

    foreach my $pkg($self->packages) {
        $self->enable($pkg);
    }
}

sub disable {
    my($self, $pkg) = @_;

    my $g = do {
        no strict 'refs';
        \*{ $pkg . '::' };
    };
    $self->{originals}{$pkg} = *{$g}{HASH};

    *{$g} = \%Scope::Ban::__null__;
    return;
}

sub enable {
    my($self, $pkg) = @_;

    my $g = do {
        no strict 'refs';
        \*{ $pkg . '::' };
   };
   *{$g} = $self->{originals}{$pkg};
   return;
}

{
    package
        Scope::Ban::__null__;
}

1;
__END__

=head1 NAME

Scope::Ban - Disable classes in a scope

=head1 VERSION

This document describes Scope::Ban version 0.01.

=head1 SYNOPSIS

    use Scope::Ban;

    # DBI and Cache::Memcached::Fast are available

    {
        my $guard = Scope::Ban->new(qw(DBI Cache::Memcached::Fast));

        # DBI and Cache::Memcached::Fast are not available

        ...;
    }

    # DBI and Cache::Memcached::Fast are available, again

=head1 DESCRIPTION

This module disables specified classes in a scope.

=head1 INTERFACE

# TODO

=head1 DEPENDENCIES

Perl 5.8.1 or later.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 SEE ALSO

L<Scope::Guard>

=head1 AUTHOR

Fuji, Goro (gfx) E<lt>gfuji@cpan.orgE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2011, Fuji, Goro (gfx). All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
