requires 'CGI::Deurl::XS';
requires 'CHI';
requires 'CHI::Driver::Redis';
requires 'Class::XSAccessor';
requires 'Cpanel::JSON::XS';
requires 'Dancer2';
requires 'Dancer2::Debugger';
requires 'Dancer2::Logger::LogAny';
requires 'Dancer2::Plugin::Cache::CHI';
requires 'Dancer2::Session::CHI';
requires 'Data::Compare';
requires 'Email::Sender::Simple';
requires 'Email::Sender::Transport';
requires 'Email::Simple';
requires 'Email::Simple::Creator';
requires 'Git::Wrapper';
requires 'HTTP::Parser::XS';
requires 'HTTP::XSCookies';
requires 'MetaCPAN::Client';
requires 'Method::Signatures';
requires 'Module::Load';
requires 'Path::Tiny';
requires 'Plack';
requires 'Redis';
requires 'Template';
requires 'URL::Encode::XS';
requires 'YAML::XS';

on test => sub {
    requires 'HTTP::Request::Common';
    requires 'Plack::Test';
};

# END
