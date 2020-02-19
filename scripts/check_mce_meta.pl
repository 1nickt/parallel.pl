use strict; use warnings;
use 5.30.1;

BEGIN {
    use Path::Tiny;
    push @INC, sprintf '%s/lib', path(__FILE__)->parent->parent->realpath;
}

use Time::Piece;
use Log::Any '$log';
use Log::Any::Adapter (File => '/tmp/MDA-app.log');
use Getopt::Long 'GetOptions';

use MDA::ModuleMetaData;

my $send_mail = '';
GetOptions( send_mail => \$send_mail );

$log->info('Starting mce_meta check at ' . gmtime->datetime);
MDA::ModuleMetaData->new( send_mail => $send_mail )->check_and_update;
$log->info('Completed mce_meta check at ' . gmtime->datetime);

__END__
