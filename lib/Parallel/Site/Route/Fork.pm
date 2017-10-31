=head1 NAME

Parallel::Site::Route::Fork - Handles /fork

=cut

package Parallel::Site::Route::Fork;

use Dancer2 appname => 'Parallel::Site';
use Path::Tiny;
#use PPI::Prettify;
use PPI::HTML;
use FindBin qw/ $RealBin /;

get '/fork' => sub {
    return template 'fork', {
        title     => 'fork',
        code_01   => _codify('fork-01.pl'),
        output_01 => _codify('fork-01.pl.out'),
        code_02   => _codify('fork-02.pl'),
        output_02 => _codify('fork-02.pl.out'),
    };
};

sub _codify {
    my $file_name = shift;
    my $path = "$RealBin/../public/code/$file_name";
    my $code = PPI::Document->new( $path );

    return _outputify( $code ) if $file_name =~ /\.out$/;
    my $PPI  = PPI::HTML->new;
    my $html = $PPI->html( $code );

    return _prepare_output( $html );
}

sub _outputify {
    my $code        = shift;
    my @lines       = split "\n", $code;
    my $line_number = 0;
    my $output;
    for ( @lines ) {
        my $class = ++$line_number == 1 ? 'prompt' : 'word';
        $output .= qq{<span class="$class">$_</span><br>};
    }

    return _prepare_output( $output );
}

sub _prepare_output {
    my $text = shift;

    $text =~ s/<BR>/\n/gi;
    $text =~ s/\n{2}/\n/msg;
    $text =~ s/(?:\A\s+|\s+\Z)//msg;
    
    return $text;
}

1; # return true

__END__
