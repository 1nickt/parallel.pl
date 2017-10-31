use strict; use warnings;

use FindBin qw/ $RealBin /;
use lib "$RealBin/../lib";

use Parallel::Site;

Parallel::Site->to_app;

__END__

