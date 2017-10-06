use strict; use warnings;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;

use MDA;
my $app = 'MDA'->to_app;
my $test = Plack::Test->create( $app );

{
    my $response = $test->request( GET '/' );
    is $response->code, 200,                              'Got a 200 response code from "/"';
    like $response->decoded_content, qr/Parallel Perl/,   'Content as expected';
}

done_testing;

__END__ 

