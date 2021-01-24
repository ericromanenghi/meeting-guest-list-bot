package MeetingBot::Role::Error;

use Moose::Role;

requires '_build_error_code';
requires '_build_description';
requires '_build_is_public';

has 'code' => (
    is      => 'ro',
    isa     => 'Int',
    lazy    => 1,
    builder => '_build_error_code',
);

# Error description. Only to be displayed in logs, never returned to the user
has 'description' => (
    is => 'ro',
    isa => 'Str',
    lazy => 1,
    builder => '_build_description'
);

# Indicates whether should we notify user about this error or not
# If is_public is true, message MUST be provided and has ot be non-empty
# If is_public is false, message MUST be undefined
has 'is_public' => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    builder => '_build_is_public',
);

# Text to be showed to the user
has 'message' => (
    is        => 'ro',
    isa       => 'Maybe[Str]',
    lazy      => 1,
    builder   => '_build_message',
    predicate => 'has_message',
);

has 'logger' => (
    is   => 'ro',
    isa  => 'MeetingBot::Logger',
    lazy => 1,
    default => sub { MeetingBot::Logger->new() },
);

# Telegram client
has 'api' => (
    is  => 'ro',
    isa => 'WWW::Telegram::BotAPI',
);

has 'chat_id' => (
    is        => 'ro',
    isa       => 'Int',
    predicate => 'has_chat_id',
);

sub process {
    my ($self) = @_;

    die "Message provided for non-public error" if !$self->is_public && $self->has_message;
        
    die "Message has to provided and non-empty for public errors" if $self->is_public && (!$self->has_message || !$self->message);

    $self->logger->log_stderr($self->description);

    return unless $self->is_public;

    die "Chat id must be provided" unless $self->has_chat_id;

    $self->api->sendMessage({
        chat_id => $self->chat_id,
        text    => $self->message
    });

    return;
}

1;