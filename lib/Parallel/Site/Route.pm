=head1 NAME

Parallel::Site::Route - The route handler loader

=cut

use Dancer2;
use Module::Load;

my $base = 'Parallel::Site::Route::';

my %required_modules = (
    'Fork'       => 1,
    'Contact'    => 0,
);

load( $base . $_ ) for grep { $required_modules{ $_ } == 1 } ( keys %required_modules );

get '/' => sub {
    template 'index', {
        title => 'Home',
    };
};

get '/threads' => sub {
     template 'threads', {
        title => 'Threads',
    };
};

get '/mce' => sub {
     template 'mce', {
        title => 'Perl Multi-Core Engine',
    };
};

get '/about' => sub {
    template 'about', {
        title => 'About',
    };
};

1; # return true

