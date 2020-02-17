package MDA::App;

use strict; use warnings;
use 5.30.1;
use Module::Runtime 'require_module';
use Dancer2;

use MDA::App::Plugin::ModuleMetaData;

get '/' => sub {
    debug "in /";
    template 'index', { mce_meta => mce_meta };
};

#---------------------------#

# Optionally load route handlers
my $prefix = 'MDA::App::Route';

my %required_modules = (
    'Contact'    => 0,
    'EmailLists' => 1,
);

require_module( join('::', $prefix, $_) ) for grep { $required_modules{ $_ } == 1 } ( keys %required_modules );

1; # return true

__END__

=head1 NAME

MDA::App - Dancer2 App for the MCE website

=head1 DESCIPTION

MDA : "MCE Dancer App"

To add a route to the server, write a class under C<MDA::App::Route>, and add its name to C<%required_modules>.

=head1 SYNOPSIS

  plackup bin/app.psgi;

=head1 METHODS

None

=head1 SEE ALSO

L<Dancer2>

=cut
