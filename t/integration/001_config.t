#! perl

use Modern::Perl;

use Test::More;

subtest 'Config, expected case' => sub {
    use_ok('MeetingBot::Config');

    my $config = MeetingBot::Config->new(
        config_file => 'config/dev.yaml',
    );

    is($config->get('token'), 'fake-dev-token', 'Access config value');
};

done_testing();