package MeetingBot::Constants;

use Modern::Perl;

use Exporter 'import';

use constant {
    # ERRORS
    ERROR_UNKNOWN                 => 1,
    ERROR_UNSUPPORTED_UPDATE_TYPE => 2,
    ERROR_INVALID_COMMAND         => 3,

};

our @EXPORT_OK;
our %EXPORT_TAGS = (
    errors => [qw(
        ERROR_UNKNOWN
        ERROR_UNSUPPORTED_UPDATE_TYPE
        ERROR_INVALID_COMMAND
    )],
);

Exporter::export_ok_tags('errors');

1;