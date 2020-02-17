use strict; use warnings;
use 5.30.1;

use Log::Any '$log';
use Log::Any::Adapter 'Stderr';
use Getopt::Long 'GetOptions';

use MDA::ModuleMetaData;

my $send_mail;
GetOptions( send_mail => \$send_mail );

MDA::ModuleMetaData->new( send_mail => $send_mail )->check_and_update;

__END__
