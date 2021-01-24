#! perl

use Test::More;
use Test::MockModule;

BEGIN {
    $INC{'MeetingBot/Command/Builder.pm'} = 1;
}

subtest 'New event, no title' => sub {
    my $builder = Test::MockModule->new('MeetingBot::Command::Builder');
    $builder->mock(create => sub {
        my ($args) = @_;

        is($args->{command}, 'new_event', 'Correct command');
        is($args->{raw_text}, '', 'Correct raw_text');
    });

    require MeetingBot::Parser::Updates;

    my ($command, $error) = MeetingBot::Parser::Updates::parse({
        update_id => 1,
        message   => { text => '/new' }
    });

    ok(!defined $error, 'No error');

    $builder->unmock_all();
};

subtest 'New event, title' => sub {
    my $builder = Test::MockModule->new('MeetingBot::Command::Builder');
    $builder->mock(create => sub {
        my ($args) = @_;

        is($args->{command}, 'new_event', 'Correct command');
        is($args->{raw_text}, ' <title>', 'Correct raw_text');
    });

    require MeetingBot::Parser::Updates;

    my ($command, $error) = MeetingBot::Parser::Updates::parse({
        update_id => 1,
        message   => { text => '/new <title>' }
    });

    ok(!defined $error, 'No error');

    $builder->unmock_all();
};

subtest 'Add guest, no name' => sub {
    my $builder = Test::MockModule->new('MeetingBot::Command::Builder');
    $builder->mock(create => sub {
        my ($args) = @_;

        is($args->{command}, 'add_guest', 'Correct command');
        is($args->{raw_text}, '', 'Correct raw_text');
    });

    require MeetingBot::Parser::Updates;

    my ($command, $error) = MeetingBot::Parser::Updates::parse({
        update_id => 1,
        message   => { text => '+' }
    });

    ok(!defined $error, 'No error');

    $builder->unmock_all();
};

subtest 'Add guest, with name' => sub {
    my $builder = Test::MockModule->new('MeetingBot::Command::Builder');
    $builder->mock(create => sub {
        my ($args) = @_;

        is($args->{command}, 'add_guest', 'Correct command');
        is($args->{raw_text}, ' <name>', 'Correct raw_text');
    });

    require MeetingBot::Parser::Updates;

    my ($command, $error) = MeetingBot::Parser::Updates::parse({
        update_id => 1,
        message   => { text => '+ <name>' }
    });

    ok(!defined $error, 'No error');

    $builder->unmock_all();
};

subtest 'Remove guest, no identifier' => sub {
    my $builder = Test::MockModule->new('MeetingBot::Command::Builder');
    $builder->mock(create => sub {
        my ($args) = @_;

        is($args->{command}, 'remove_guest', 'Correct command');
        is($args->{raw_text}, '', 'Correct raw_text');
    });

    require MeetingBot::Parser::Updates;

    my ($command, $error) = MeetingBot::Parser::Updates::parse({
        update_id => 1,
        message   => { text => '-' }
    });

    ok(!defined $error, 'No error');

    $builder->unmock_all();
};

subtest 'Remove guest, with identifier' => sub {
    my $builder = Test::MockModule->new('MeetingBot::Command::Builder');
    $builder->mock(create => sub {
        my ($args) = @_;

        is($args->{command}, 'remove_guest', 'Correct command');
        is($args->{raw_text}, ' <identifier>', 'Correct raw_text');
    });

    require MeetingBot::Parser::Updates;

    my ($command, $error) = MeetingBot::Parser::Updates::parse({
        update_id => 1,
        message   => { text => '- <identifier>' }
    });

    ok(!defined $error, 'No error');

    $builder->unmock_all();
};

# Even though the command argument is invalid, the update is still valid
# This will return an error, that's why we don't check for that condition
# (a separate test will be added to cover invalid arguments)
subtest 'Add note, no note' => sub {
    my $builder = Test::MockModule->new('MeetingBot::Command::Builder');
    $builder->mock(create => sub {
        my ($args) = @_;

        is($args->{command}, 'add_note', 'Correct command');
        is($args->{raw_text}, '', 'Correct raw_text');
    });

    require MeetingBot::Parser::Updates;

    my ($command, $error) = MeetingBot::Parser::Updates::parse({
        update_id => 1,
        message   => { text => '++' }
    });

    $builder->unmock_all();
};

subtest 'Add note' => sub {
    my $builder = Test::MockModule->new('MeetingBot::Command::Builder');
    $builder->mock(create => sub {
        my ($args) = @_;

        is($args->{command}, 'add_note', 'Correct command');
        is($args->{raw_text}, ' <note>', 'Correct raw_text');
    });

    require MeetingBot::Parser::Updates;

    my ($command, $error) = MeetingBot::Parser::Updates::parse({
        update_id => 1,
        message   => { text => '++ <note>' }
    });

    ok(!defined $error, 'No error');

    $builder->unmock_all();
};

subtest 'Remove note, no identifier' => sub {
    my $builder = Test::MockModule->new('MeetingBot::Command::Builder');
    $builder->mock(create => sub {
        my ($args) = @_;

        is($args->{command}, 'remove_note', 'Correct command');
        is($args->{raw_text}, '', 'Correct raw_text');
    });

    require MeetingBot::Parser::Updates;

    my ($command, $error) = MeetingBot::Parser::Updates::parse({
        update_id => 1,
        message   => { text => '--' }
    });

    ok(!defined $error, 'No error');

    $builder->unmock_all();
};

subtest 'Remove note, with identifier' => sub {
    my $builder = Test::MockModule->new('MeetingBot::Command::Builder');
    $builder->mock(create => sub {
        my ($args) = @_;

        is($args->{command}, 'remove_note', 'Correct command');
        is($args->{raw_text}, ' <identifier>', 'Correct raw_text');
    });

    require MeetingBot::Parser::Updates;

    my ($command, $error) = MeetingBot::Parser::Updates::parse({
        update_id => 1,
        message   => { text => '-- <identifier>' }
    });

    ok(!defined $error, 'No error');

    $builder->unmock_all();
};

done_testing();