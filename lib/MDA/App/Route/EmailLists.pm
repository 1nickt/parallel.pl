package MDA::Route::EmailLists;

use strict; use warnings;
use 5.30.1;
use Data::Dumper;
use HTTP::Tiny;
use HTTP::CookieJar;
use MIME::Base64;
use Path::Tiny;

use Dancer2 appname => 'MDA::App';

post '/list-subscribe/:list' => sub {
    my $params = params;
    my $conf   = config->{mailman}{ $params->{list} };
    my $url    = $conf->{list}{subscribe_url};
    my $email  = $params->{email};

    debug sprintf('Requesting subscribe invitation for %s', $email);

    my $match = 'Your subscription request has been received, and will soon be acted upon';
    my $response = HTTP::Tiny->new->post_form($url, { email => $email });

    if ( $response->{success} && length $response->{content} && $response->{content} =~ /$match/ ) {
        debug sprintf('Successfully requested subscribe invitation for %s', $email);
        send_as JSON => { message => q[Thanks! You'll receive a confirmation link via email soon.] };
    } else {
        my $status = "$response->{status} $response->{reason}";
        debug sprintf('Failure with request for subscribe invitation for %s: %s', $email, $status);
        send_as JSON => { error => "Sorry; that didn't work. Please retry." };
    }
};

1; # return true

__END__

=head1 NAME

MDA::App::Route::EmailLists - Provides routes for subscribing to email lists

=head1 SEE ALSO

L<MDA>

L<Dancer2>

=cut
