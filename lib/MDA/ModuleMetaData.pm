package MDA::ModuleMetaData;

use strict; use warnings;
use 5.30.1;
use Data::Dumper;

use Cpanel::JSON::XS;
use Dancer2;
use Data::Compare;
use Email::Sender::Simple;
use Email::Sender::Transport::SMTP;
use Email::Simple;
use Email::Simple::Creator;
use Git::Wrapper;
use MetaCPAN::Client;
use Method::Signatures;
use Log::Any '$log';
use Path::Tiny;
use Try::Tiny;

use Moo;
use namespace::clean;

extends 'MDA';

has send_mail  => ( is => 'ro', default => 0 );

#---------------------------------------------------------------------#
#
method check_and_update () {
    my @modules = ('MCE', 'MCE::Shared');

    my $filename = '.mce_meta';
    my $path = sprintf('%s/%s', $self->root_dir, $filename);
    my $file = path($filename);

    $log->debug('Fetching local module metadata');
    my $local_data = try {
        my $data = decode_json($file->slurp);
        die 'No metadata found in file' if  ! scalar keys %$data;
        $data;
    }
    catch {
        $log->info("Could not retrieve local metadata from file storage: $_");
        +{};
    };

    # If there is no local data, we can still continue.

    $log->debug('Fetching module metadata from CPAN');
    my $cpan_data = try {
        +{ map {
            my $release = MetaCPAN::Client->new->release( $_ =~ s/::/-/r );
            $_ => ( $release && $release->status eq 'latest' ) ? {
                version      => $release->version_numified,
                release_date => substr( $release->date, 0, 10 ),
            } : {};
        } @modules }
    }
    catch {
        $log->warn("Could not retrieve metadata from CPAN. Exiting: $_");
        +{};
    };

use Data::Dumper;
warn "CPAN: " . Dumper $cpan_data;

    # Cannot continue without data from CPAN.
    return unless (exists $cpan_data->{'MCE'}) && (exists $cpan_data->{'MCE::Shared'});

    my %updated;

    if ( ! (Compare $cpan_data->{'MCE'}, $local_data->{'MCE'}) ) {
        $log->debug('Found updated metadata for MCE');
        $updated{'MCE'}++;
    }

    if ( ! (Compare $cpan_data->{'MCE::Shared'}, $local_data->{'MCE::Shared'}) ) {
        $log->debug('Found updated metadata for MCE::Shared');
        $updated{'MCE::Shared'}++;
    }

    if ( ! keys %updated ) {
        $log->debug('Found no updated metadata');
        return;
    }

    # Updated metadata was found; write file and optionally send announcement

    $log->debug('Writing module metadata to file');

    my $commit_file = try {
        $file->spew( Cpanel::JSON::XS->new->pretty->encode($cpan_data) );
    } catch {
        $log->error("Could not write module metadata to file: $_");
        0;
    };

    return unless $commit_file;

    my $committed_and_pushed = try {
        my $git = Git::Wrapper->new( $self->root_dir );
        $git->add($path);
        $git->commit({ message => 'Update module metadata' });
        $git->push;
    }
    catch {
        $log->error("Could not commit and push module metadata file: $_");
        0;
    };

    if ( $committed_and_pushed && $self->send_mail ) {
        $self->_send_version_announcement(\%updated);
    }
}


#---------------------------------------------------------------------#
#
method _send_version_announcement ($updated) {
    $log->debug('Sending module version announcement');

    my $transport = Email::Sender::Transport::SMTP->new({
        host          => config->{email}{host},
        port          => config->{email}{port},
        sasl_username => config->{mailman}{'mce-release-announce'}{sender}{email},
        sasl_password => config->{mailman}{'mce-release-announce'}{sender}{password},
    });

    my $subject = 'MCE Version Announcement from parallel.pl';

    my $tt = Template->new({
        INCLUDE_PATH => '/usr/local/templates',
        INTERPOLATE  => 1,
    }) || $log->error("Could not initialize Template obj: $Template::ERROR");

    return unless $tt;

    $tt->process('letters/overdrawn', $_)
        || die $tt->error(), "\n";




    my $content = "QUX";

    my $email = Email::Simple->create(
        header => [
            To      => 'nick@nicktonkin.net',#$conf->{mailman}{'mce-release-announce'}{list}{email},
            From    => config->{mailman}{'mce-release-announce'}{sender}{email},
            Subject => $subject,
        ],
        body => $content,
    );

    try {
        Email::Sender::Simple->send( $email, {
            transport => $transport,
        });
    } catch {
        $log->error( $_->{message} );
    };
}

1; # return true

__END__

=head1 NAME

MDA::ModuleMetaData - Methods for fetching and handling updates to the modules' metadata

=head1 SYNOPSIS

  use MDA::ModuleMeta::Data;

=head1 METHODS

=over

=item B<data>

Fetches and returns the current module metadata from file.

=item B<send_announcement>

Sends an email message to the announcements mailman list.
=back

=head1 SEE ALSO

L<MDA::Plugin::ModuleMetaData>

L<MDA>

=cut
