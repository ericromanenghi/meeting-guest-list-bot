package MeetingBot::Error::UnsupportedUpdate;

use Moose;

with 'MeetingBot::Role::Error';

use MeetingBot::Constants qw( :errors );

has 'update_type' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

sub _build_error_code {
    return ERROR_UNSUPPORTED_UPDATE_TYPE;
}

sub _build_description {
    my ($self) = @_;
    return sprintf("Unsupported update type: %s", $self->update_type);
}

sub _build_is_public {
    return '';
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
