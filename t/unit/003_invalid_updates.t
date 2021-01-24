#! perl

use Test::More;

use MeetingBot::Constants qw( :errors );

subtest 'Unsupported interaction' => sub {
    require MeetingBot::Parser::Updates;

    my ($command, $error) = MeetingBot::Parser::Updates::parse({
        update_id              => 1,
        some_unsupported_event => {}
    });

    ok(!defined $command, 'Command is undefined');
    is($error->code, ERROR_UNSUPPORTED_UPDATE_TYPE, 'Correct error code');
    is($error->description, 'Unsupported update type: some_unsupported_event', 'Correct error description');
};

subtest 'Invalidad command' => sub {
    my @tests = (
        { update_id => 1, message => { text => '/neww asdfkop' } },
        { update_id => 1, message => { text => '+++' } },
        { update_id => 1, message => { text => '---' } },
        { update_id => 1, message => { text => 'some random text' } },
        { update_id => 1, message => { text => ' asdf + asdf' } },
    );

    require MeetingBot::Parser::Updates;

    for my $test (@tests) {
        my ($command, $error) = MeetingBot::Parser::Updates::parse($test);

        ok(!defined $command, sprintf('Command is undefined: %s', $test->{message}->{text}));
        is($error->code, ERROR_INVALID_COMMAND, sprintf('Correct error code: %s', $test->{message}->{text}));
        is(
            $error->description,
            'Invalid command',
            sprintf('Correct error description: %s', $test->{message}->{text})
        );
    }
};

done_testing();