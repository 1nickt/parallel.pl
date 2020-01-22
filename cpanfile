requires 'CHI';
requires 'CHI::Driver::Redis';
requires 'Dancer2';
requires 'Dancer2::Debugger';
requires 'Dancer2::Logger::LogAny';
requires 'Dancer2::Plugin::Cache::CHI';
requires 'Dancer2::Session::CHI';
requires 'MetaCPAN::Client';
requires 'Module::Load';
requires 'Path::Tiny';
requires 'Plack';
requires 'Redis';
requires 'Template';


on test => sub {
    requires 'HTTP::Request::Common';
    requires 'Plack::Test';
};

# END
