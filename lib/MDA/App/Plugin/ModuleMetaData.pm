package MDA::App::Plugin::ModuleMetaData;

use strict; use warnings;
use 5.30.1;

use Dancer2::Plugin;

use Method::Signatures;
use Log::Any '$log';

use MDA::ModuleMetaData;

plugin_keywords 'mce_meta';

method mce_meta {
    my $data = MDA::ModuleMetaData->new->local_data;
    $data->{mce} = delete $data->{'MCE'};
    $data->{mce_shared} = delete $data->{'MCE::Shared'};
    return $data;
}

1; # return true

__END__

=head1 NAME

MDA::Plugin::App::ModuleMetaData - Provides keywords for use when handling the modules' metadata in the MDA Dancer app

=head1 SYNOPSIS

  use Dancer2;
  use MDA::App::Plugin::ModuleMetaData; # provides 'mce_meta'

  get '/' => sub {
    template 'index', { mce_meta => mce_meta };
  };

=head1 METHODS

=over

=item B<mce_meta>

Fetches and returns a hashref containing the latest CPAN version numbers for MCE and MCE::Shared.

=back

=head1 SEE ALSO

L<MDA::ModuleMetaData>

L<MDA>

L<Dancer2>

=cut
