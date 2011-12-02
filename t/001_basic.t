#!perl -w
use strict;
use Test::More;

use Scope::Ban;

use CGI;
use File::Spec;

can_ok('CGI', qw(new header));
can_ok('File::Spec', qw(devnull join));
{
    my $gard = Scope::Ban->new(qw(CGI File::Spec));

    ok !eval {
        CGI->new();
        1;
    };
    like $@, qr/Can't locate object method "new"/;

    ok !eval {
        File::Spec->devnull();
        1;
    };
    like $@, qr/Can't locate object method "devnull"/;
}

can_ok('CGI', qw(new header));
can_ok('File::Spec', qw(devnull join));


done_testing;
