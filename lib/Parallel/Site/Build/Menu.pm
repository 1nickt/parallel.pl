use strict; use warnings; use Data::Dumper; ++$Data::Dumper::Sortkeys;

package Parallel::Site::Build::Menu;

use Moo;
extends 'Moo::Object', 'Template::Plugin';

#use MooX::TypeTiny;
use Types::Standard qw/ Str /;
use YAML::XS qw/ LoadFile /;

sub load { # required by Template::Plugin
    my ( $class, $context ) = @_;
    return $class;
}

around BUILDARGS => sub {
    my ( $orig, $class, @params ) = @_;

    my ( $tt_context, $opts ) = @params;
    my $args = {
        data    => $tt_context,
        app_dir => $opts->{'appdir'},
    };

    return $args;
};

has app_dir     => ( is => 'ro', isa => Str, required => 1 );

has config_file => (
    is => 'lazy', builder => sub {
        my $self = shift;
        return $self->app_dir . '/config/menu.yml'
    },
);

sub print_items {
    my $self = shift;
    my $config = $self->_read_config;
    return join ' ',
           map { $self->_render_html( each %{ $_ } ) }
           @{ $config };
}

sub _read_config {
    my $self = shift;
    return LoadFile( $self->config_file );
}

sub _render_html {
    my $self = shift;
    my ( $link_text, $target ) = @_;
    return qq{<a href="$target">$link_text</a>};
}

1; # return true

=head1 NAME

Parallel::Site::Build::Menu - Template plugin to uild a responsive HTML menu from config

=head1 SYNOPSIS

  use Parallel::Site::Build::Menu;

=head1 SEE ALSO

L<Template>

=cut

__END__


