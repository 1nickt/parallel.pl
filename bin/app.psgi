use strict; use warnings;
use 5.30.1;
use Path::Tiny;
use Plack::Builder;
use Dancer2::Debugger;
use Plack::Debugger::Panel::Dancer2::Logger;

BEGIN {
    push @INC, sprintf '%s/lib', path($0)->parent->parent->realpath;
}

my $debugger = Dancer2::Debugger->new;

use MDA;
my $app = MDA->to_app;

builder {
    $debugger->mount;
    mount '/' => builder {
        $debugger->enable;
        $app;
    }
};

__END__
