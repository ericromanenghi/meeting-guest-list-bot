#! perl

use Modern::Perl;

use MeetingBot::Loop;
use MeetingBot::Logger qw(log_stderr);

main();
exit;

sub main {
    log_stderr("Bot started");

    my $loop = MeetingBot::Loop->new(
        config_file => 'config/prod.yaml'
    );

    $loop->start();
}