package MeetingBot::Error::InvalidCommand;

use Moose;

with 'MeetingBot::Role::Error';

use MeetingBot::Constants qw( :errors );

sub _build_error_code {
    return ERROR_INVALID_COMMAND;
}

sub _build_description {
    my ($self) = @_;
    return "Invalid command";
}

sub _build_is_public {
    return '';
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
