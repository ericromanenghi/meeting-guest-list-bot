package MeetingBot::Logger;

use Moose;

use POSIX qw(strftime);

sub log_stderr {
    my $self = shift;

    while (@_) {
        print STDERR sprintf("%s - %s\n", strftime("%x %X", localtime()), shift @_);
    }

    return;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;