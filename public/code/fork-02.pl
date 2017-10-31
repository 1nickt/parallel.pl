use strict; use warnings;
use feature qw/ say /;

use Time::HiRes qw/ time usleep /;

sub say_numbers { usleep(750000) and say "$_[0] $_" for 0 .. 5 }
sub say_letters { usleep(500000) and say "$_[0] $_" for 'a' .. 'e' }

my $start = time;

my $child_pid = fork;

if ( $child_pid ) {            # parent
    say_numbers("$$ parent");
} elsif ( $child_pid == 0 ) {  # child
    say_letters("$$ child");
} else {
    die "fork failed!";
}

my $elapsed = time - $start;

say sprintf '%s done in %.3fs', $$, $elapsed;

__END__
