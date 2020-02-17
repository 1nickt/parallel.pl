package MDA;

use strict; use warnings;
use 5.30.1;
use Path::Tiny;

use Moo;
use namespace::clean;

has root_dir => (
    is      => 'lazy',
    builder => sub {
        my $dir = path($0)->parent;
        $dir = $dir->parent until $dir->child('.mda_base')->exists or $dir->is_rootdir;
        return $dir->realpath;
    },
);

1; # return true

__END__

=head1 NAME

MDA - Base class for the MCE website backend code

=head1 DESCIPTION

MDA : "MCE Dancer App"

=head1 SYNOPSIS

    use MDA;

    my $mda = MDA->new;

=head1 ATTRIBUTES

=over

=item B<root_dir>

The root directory for the entire codebase. Built lazily by searching for the C<.mda_base> file's parent folder.

=head1 SEE ALSO

L<MDA::App> - the Dancer2 app

=cut
