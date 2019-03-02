package Bonkers::Cracker;

use Bonkers::Pragmas;

my @reportAttributes = qw(colour gift status box);

my $logger = Bonkers::Logger->get();

sub new($class, $params) {
  $logger->trace(np($params));

  my $self = bless($params, $class);
  $self->status('new');
  return $self;
}

=head2 box

 @param {Bonkers::Box} OPTIONAL. Set the box this Cracker is in instead of getting the Box.
 @returns {Bonkers::Box or undef} In which Box this Cracker is?

=cut

sub box($self, $box=undef) {
  if ($box) {
    $self->{box} = $box;
    weaken $self->{box}; #Box to Cracker link is the string one.
  }
  return $self->{box};
}

=head2 colour

 @returns {String} Colour of this Cracker

=cut

sub colour($self) { return $self->{colour} // die $self." colour not set"; }

=head2 gift

 @returns {String} type of Gift this Cracker has inside.

=cut

sub gift($self) { return $self->{gift} // die $self." gift not set"; }

=head2 status

 @param {String or undef} Set or get status text
 @returns {Bonkers::Cracker} Self

=cut

sub status($self, $status=undef) {
  $self->{status} = $status if $status;
  return $self->{status};
}

sub report($self) {
  my %report = %$self{@reportAttributes};
  $report{box} = ($report{box}) ? $report{box}->colour : '';

  return \%report;
}

1;
