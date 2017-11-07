requires 'Dancer2';
requires 'Path::Tiny';
requires 'PPI::HTML';

on test => sub {
    requires 'HTTP::Request::Common';
    requires 'Plack::Test';
};

# END

