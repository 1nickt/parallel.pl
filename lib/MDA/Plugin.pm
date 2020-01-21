package MDA::Plugin;

use strict; use warnings;
use 5.30.1;
use Dancer2::Plugin;
use Dancer2::Plugin::Cache::CHI;
use MetaCPAN::Client;
use Data::Dumper;

plugin_keywords qw/
    mce_meta
/;

sub mce_meta {
    my $self = shift;
    $self->dsl->debug('building MCE metadata');

    my $cache_key = 'mce_meta';

    my $data = cache_get($cache_key);

    if ( ! $data ) {
        $self->dsl->debug('metadata not found in cache');

        for ('MCE', 'MCE::Shared') {
            my $module = MetaCPAN::Client->new->module($_);

            if ( $module && $module->status eq 'latest' ) {
                $data->{ $_ } = {
                    version      => $module->version,
                    release_date => substr($module->date, 0, 10),
                };
            }
        }

        $self->dsl->debug('metadata from MetaCPAN: ' . Dumper $data);
    }

    $data->{mce} = delete $data->{'MCE'};
    $data->{mce_shared} = delete $data->{'MCE::Shared'};

    return $data;
}

1; # return true

__END__

=head1 NAME

MDA::DSL - Methods for use in the MDA Dancer app

=head1 DESCRIPTION

Encapsulates functionality in keywords made availbe to route handlers in the app.

=head1 SYNOPSIS

In the main app class:

  use Dancer2 dsl => 'MDA::DSL';

=head1 METHODS

None

=head1 SEE ALSO

L<MDA>

L<Dancer2>

=cut
