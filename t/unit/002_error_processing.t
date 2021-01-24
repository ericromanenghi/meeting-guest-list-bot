#! perl

use Test::More;
use Test::MockObject;

subtest 'process error, invalid errors' => sub {
    require MeetingBot::Error::Unknown;

    # Invalid error
    my $non_public_error_with_message = MeetingBot::Error::Unknown->new(
        message => 'Some message for user'
    );

    my $test_name = "Non public error with message";
    eval {
        $non_public_error_with_message->process();
        fail($test_name);
        1;
    } or do {
        my $msg = $@;
        ok(
            $msg =~ m/^Message provided for non-public error.*/,
            $test_name
        );
    };

    # Invalid error
    my $public_error_without_message = MeetingBot::Error::Unknown->new(
        is_public => 1,
    );

    $test_name = "Public error without message";
    eval {
        $public_error_without_message->process();
        fail($test_name);
        1;
    } or do {
        my $msg = $@;
        ok(
            $msg =~
            m/^Message has to provided and non-empty for public errors.*/,
            $test_name
        );
    };

    # Invalid error
    my $public_error_with_undefined_message = MeetingBot::Error::Unknown->new(
        is_public => 1,
        message   => undef,
    );

    $test_name = "Public error without message";
    eval {
        $public_error_with_undefined_message->process();
        fail($test_name);
        1;
    } or do {
        my $msg = $@;
        ok(
            $msg =~
            m/^Message has to provided and non-empty for public errors.*/,
            $test_name
        );
    };

    # Invalid error
    my $public_error_with_empty_message = MeetingBot::Error::Unknown->new(
        is_public => 1,
        message   => '',
    );

    $test_name = "Public error without message";
    eval {
        $public_error_with_empty_message->process();
        fail($test_name);
        1;
    } or do {
        my $msg = $@;
        ok(
            $msg =~
            m/^Message has to provided and non-empty for public errors.*/,
            $test_name
        );
    };
};

subtest 'process error, non public error' => sub {
    my $logger = Test::MockObject->new();
    $logger->set_isa('MeetingBot::Logger');
    $logger->mock(log_stderr => sub {
        my ($self, $description) = @_;

        ok($description, "Description is non empty");

        return;
    });

    my $error = MeetingBot::Error::Unknown->new(
        logger => $logger
    );

    my $test_name = "Process error";
    eval {
        $error->process();
        pass($test_name);
        1;
    } or do {
        fail($test_name);
    };
};

subtest 'process error, non public error' => sub {
    my $chat_id = 42;
    my $message = "Some message";

    my $api = Test::MockObject->new();
    $api->set_isa('WWW::Telegram::BotAPI');
    $api->mock('sendMessage' => sub {
        my ($self, $args) = @_;

        is($args->{chat_id}, 42, "Valid chat id");
        is($args->{text}, $message,  "Valid text");

        return;
    });

    my $logger = Test::MockObject->new();
    $logger->set_isa('MeetingBot::Logger');
    $logger->mock(log_stderr => sub {
        my ($self, $description) = @_;

        ok($description, "Description is non empty");

        return;
    });

    my $public_error_missing_chat_id = MeetingBot::Error::Unknown->new(
        is_public => 1,
        message   => $message,
        logger    => $logger,
        api       => $api,
    );

    my $test_name = "missing chat id";
    eval {
        $public_error_missing_chat_id->process();
        fail($test_name);
        1;
    } or do {
        my $msg = $@;
        ok($msg =~ "^Chat id must be provided.*", $test_name);
    };

    my $public_error = MeetingBot::Error::Unknown->new(
        is_public => 1,
        message   => $message,
        logger    => $logger,
        api       => $api,
        chat_id   => $chat_id
    );

    my $test_name = "Expected case";
    eval {
        $public_error->process();
        pass($test_name);
        1;
    } or do {
        fail($test_name);
    };
};

done_testing();