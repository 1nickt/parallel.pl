use strict; use warnings; use Data::Dumper; ++$Data::Dumper::Sortkeys;

package MDA;

use Dancer2;
set charset  => 'UTF-8';
set template => 'simple';

get '/' => sub {
    template 'index';
};

1; # return true

__END__



1; # return true

=head1 NAME

MDA - MCE Dancer2 App

=head1 SYNOPSIS

  plackup bin/app.psgi;

=head1 METHODS

None

=head1 SEE ALSO

L<Dancer2>

=cut



