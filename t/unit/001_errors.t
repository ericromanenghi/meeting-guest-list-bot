#! perl

use Test::More;

use MeetingBot::Constants qw( :errors );

subtest 'unknown error' => sub {
    require MeetingBot::Error::Unknown;

    my $unknown_error = MeetingBot::Error::Unknown->new();

    is($unknown_error->code, ERROR_UNKNOWN, 'Correct error code');
    ok($unknown_error->description, 'Description provided');
    ok(!$unknown_error->is_public, 'Error is no public');
};

done_testing();