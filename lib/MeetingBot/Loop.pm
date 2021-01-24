package MeetingBot::Loop;

use Moose;

use WWW::Telegram::BotAPI;

use MeetingBot::Config;
use MeetingBot::Logger;

has 'api' => (
    is      => 'ro',
    isa     => 'WWW::Telegram::BotAPI',
    lazy    => 1,
    builder => '_build_api',
);

has 'logger' => (
    is => 'ro',
    isa => 'MeetingBot::Logger',
    lazy => 1,
    default => sub { MeetingBot::Logger->new() },
);

has 'config' => (
    is      => 'ro',
    isa     => 'MeetingBot::Config',
    lazy    => 1,
    builder => '_build_config',
);

has 'config_file' => (
    is       => 'ro',
    isa      => 'Str',
);

has 'timeout' => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    builder => '_build_timeout',    
);

has 'token' => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    builder => '_build_token',
);

sub start {
    my ($self) = @_;

    my $offset;
    while (1) {
        $self->logger->log_stderr("Polling...");

        # TODO: consider retries (check first if client is not already doing them)
        my $response = $self->api->getUpdates({
            timeout         => $self->timeout,
            allowed_updates => ['message'],
            $offset ? (offset  => $offset) : (),
        });

        if ($response->{ok}) {
            my $processed = 0;
            my $total = scalar @{$response->{result}};
            for my $update (@{$response->{result}}) {
                $self->logger->log_stderr(sprintf("Processing request %s/%s", $processed + 1, $total));

                my ($command, $error) = MeetingBot::Parser::Updates::parse($update);
                
                if ($error) {
                    $error->process();
                    next;
                }

                $self->logger->log_stderr("Executing command");
                
                my ($success, $message) = $command->execute($self->api);

                if ($success) {
                    $self->logger->log_stderr("Done, let's move to the next one!");
                    $offset = $update->{update_id} + 1;
                } else {
                    $self->logger->log_stderr("Ups! Something went wrong: $message");
                }
            }
        }
    }

    return;
}

sub _build_api {
    my ($self) = @_;

    return WWW::Telegram::BotAPI->new(
        token => $self->token,
    );
}

sub _build_config {
    my ($self) = @_;

    return MeetingBot::Config->new(
        config_file => $self->config_file
    );
}

sub _build_timeout {
    my ($self) = @_;

    return $self->config->get('timeout');
}

sub _build_token {
    my ($self) = @_;

    return $self->config->get('token');
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;