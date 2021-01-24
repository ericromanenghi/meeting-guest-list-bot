package MeetingBot::Config;

use Moose;
use YAML::Tiny;

has 'config_file' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'parsed_object' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    builder => '_build_parsed_object',
);

sub get {
    my ($self, $field) = @_;

    return $self->_get_field($field);
}

sub _build_parsed_object {
    my ($self) = @_;

    my $yaml = YAML::Tiny->read($self->config_file);

    die "Config file should have only one document" unless @$yaml == 1;

    return $yaml->[0];
}

sub _get_field {
    my ($self, $field) = @_;

    die "$field is required" unless $self->parsed_object->{$field};

    return $self->parsed_object->{$field};
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;