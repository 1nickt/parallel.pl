package MDA::Plugin;

use strict; use warnings;
use 5.30.1;
use Dancer2::Plugin;
use Dancer2::Plugin::Cache::CHI;
use MetaCPAN::Client;
use Data::Dumper;
use Log::Any '$log';

plugin_keywords qw/
    mce_meta
/;

sub mce_meta {
    my $self = shift;
    $log->debug('building MCE metadata');

    my $cache_key = 'mce_meta';

    my $data = cache_get($cache_key) || {};

    if ( ! $data->{MCE} ) {
        for ('MCE', 'MCE::Shared') {
            my $module = MetaCPAN::Client->new->module($_);
            if ( $module && $module->status eq 'latest' ) {
                $data->{ $_ } = {
                    version      => $module->version,
                    release_date => substr( $module->date, 0, 10 ),
                };
            }
        }

        if ( keys %{ $data } == 2 ) { # only cache if it's good data
            cache_set($cache_key, $data, 900); # force new lookup after 15 minutes
        }
    }

    $data->{mce} = delete $data->{'MCE'};
    $data->{mce_shared} = delete $data->{'MCE::Shared'};

    return $data;
}

1; # return true

__END__

=head1 NAME

MDA::Plugin - Methods providing keywords for use in the MDA Dancer app

=head1 DESCRIPTION

Encapsulates functionality in keywords made availbe to route handlers in the app.

=head1 SYNOPSIS

  use Dancer2;
  use MDA::Plugin; # provides 'mce_meta'

  get '/' => sub {
    template 'index', { mce_meta => mce_meta };
  };

=head1 METHODS

=over

=item B<mce_meta>

Fetches and returns a hashref containing the latest CPAN version numbers for MCE and MCE::Shared.

=back

=head1 SEE ALSO

L<MDA>

L<Dancer2>

=cut
