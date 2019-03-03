package Bonkers::Logger;

=head1 NAME

Bonkers::Logger

=head2 SYNOPSIS

!!Copypaste from a previous project!!

Logger to trace what happens inside the app.

=cut

use Scalar::Util qw(blessed);

use Log::Log4perl;
use parent 'Log::Log4perl';
Log::Log4perl->wrapper_register(__PACKAGE__);

=head2

Get a package-level logger for your calling package/class.

 @returns {Log::Log4perl::Logger}

=cut

sub get {
  return Log::Log4perl->get_logger(caller);
}

# Automatically init the Log::Log4perl subsystem on first module load/use.
# Differentiate logging from the program output, so we can capture STDOUT as the result, and STDERR as logging/debugging
my $conf = q(
  log4perl.rootLogger = INFO, SCREEN

  log4perl.appender.SCREEN = Log::Log4perl::Appender::ScreenColoredLevels
  log4perl.appender.SCREEN.layout=PatternLayout
  log4perl.appender.SCREEN.layout.ConversionPattern=%d [%p] %M %m{indent}%n
  log4perl.appender.SCREEN.utf8=1
  log4perl.appender.SCREEN.stderr=1
);

Log::Log4perl::init( \$conf );

1;
