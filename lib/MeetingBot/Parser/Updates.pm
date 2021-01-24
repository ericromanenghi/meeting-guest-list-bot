package MeetingBot::Parser::Updates;

use Modern::Perl;

use String::Util qw(trim);

use MeetingBot::Error::UnsupportedUpdate;
use MeetingBot::Error::InvalidCommand;
use MeetingBot::Command::Builder;

# Returns a (MeetingBot::Command, MeetingBot::Error) pair
# Exactly one of the elements in the pair MUST be undefined
sub parse {
    my ($update) = @_;

    if (!$update->{message}) {
        my ($update_type) = grep { $_ ne 'update_id' } keys %$update;

        return (undef, MeetingBot::Error::UnsupportedUpdate->new(
            update_type => $update_type,
        ));
    }

    my $text = trim($update->{message}->{text}, right => 0);

    if ($text =~ m!^/ne(w$|w\s.*)!) {
        return MeetingBot::Command::Builder::create({
            command  => 'new_event',
            raw_text => $text =~ s!/new!!r,
        });
    }

    if ($text =~ m!(^\+$|^\+\s.*)!) {
        return MeetingBot::Command::Builder::create({
            command  => 'add_guest',
            raw_text => $text =~ s!\+!!r,
        });
    }

    if ($text =~ m!(^-$|^-\s.*)!) {
        return MeetingBot::Command::Builder::create({
            command  => 'remove_guest',
            raw_text => $text =~ s!-!!r,
        });
    }

    if ($text =~ m!(^\+\+$|^\+\+\s.*)!) {
        return MeetingBot::Command::Builder::create({
            command  => 'add_note',
            raw_text => $text =~ s!\+\+!!r,
        });
    }

    if ($text =~ m!(^--$|^--\s.*)!) {
        return MeetingBot::Command::Builder::create({
            command  => 'remove_note',
            raw_text => $text =~ s!--!!r,
        });
    }

    return (undef, MeetingBot::Error::InvalidCommand->new());
}

1;