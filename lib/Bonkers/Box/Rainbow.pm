package Bonkers::Box::Rainbow;

use Bonkers::Pragmas;

use Bonkers::Box;
use parent 'Bonkers::Box';

my $logger = Bonkers::Logger->get();

=head2 new

!!! Initially I thought it would be a cool trick to overload the place()-logic in Bonkers::Box::place()
with a closure for the special rainbow Box case, but that would just deviate from the standard OO
patterns too much and make things more ugly. For the placing logic there was no other reasonable
place than it's own class !!!


Instantiate a new rainbow Box.

=cut

sub new($class) {
  my $self = bless({colour => 'rainbow'}, $class);
  $self->{crackersByColour} = {}; #Store the crackers by the colour and gift, so we can easily lookup if the incoming gift or colour already exists.
  return $class->SUPER::new($self);
}

=head2 place

See Bonkers::Box::place()

=cut

sub place($self, $cracker) {
  if ($self->crackers->{ $cracker->gift }) {
    die "Gift '".$cracker->gift."' already exists in the '".$self->colour."' box!";
  }
  if ($self->{crackersByColour}->{ $cracker->colour }) {
    die "Colour '".$cracker->colour."' already exists in the '".$self->colour."' box!";
  }

  $cracker->box($self);
  $self->crackers->{ $cracker->gift } = $cracker;
  $self->{crackersByColour}->{ $cracker->colour } = $cracker;

  $logger->trace(np($self)."\n".np($cracker)) if $logger->is_trace();
  return $self;
}

1;
