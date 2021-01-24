package MeetingBot::Error::Unknown;

use Moose;

with 'MeetingBot::Role::Error';

use MeetingBot::Constants qw( :errors );

sub _build_error_code {
    return ERROR_UNKNOWN;
}

sub _build_description {
    return "Something went wrong and we have no idea why";
}

sub _build_is_public {
    return '';
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
