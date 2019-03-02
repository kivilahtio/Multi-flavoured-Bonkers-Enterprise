package Bonkers::Worker;

use Bonkers::Pragmas;
use Bonkers::Cracker;

use Bonkers::Mixin::HasCracker;
use parent 'Bonkers::Mixin::HasCracker';

my $logger = Bonkers::Logger->get();

sub new($class, $params) {
  $logger->trace(np($params));

  return bless($params, $class);
}

sub assemble($self) {
  return $self->crackerAtHand(shift(@{$self->feed()})) if ($self->feed);
  return $self->crackerAtHand($self->getNewCracker());
}

=head2 dispatch

Dispatch the Cracker to the registered Packer via the conveyer belt.

 @returns {Bonkers::Worker} Self

=cut

sub dispatch($self) {
  $self->packer->crackerAtHand($self->crackerAtHand);
  $self->crackerAtHand(0);

  return $self;
}

=head2 getNewCracker

 @returns {Bonkers::Cracker} A random Cracker from the given colours and gifts,
                             or the next Cracker from a predetermined feed of Crackers.

=cut

sub getNewCracker($self) {
  my $randColour = $self->colours()->[ rand(scalar(@{$self->colours})) ];
  my $randGift =   $self->gifts()->[   rand(scalar(@{$self->gifts})) ];
  my $cracker = Bonkers::Cracker->new({colour => $randColour, gift => $randGift});

  $logger->trace(np($cracker)) if $logger->is_trace();
  return $cracker;
}

sub colours($self) { return $self->{colours} // die $self." colours not set"; }
sub feed($self)    { return $self->{feed}; }
sub gifts($self)   { return $self->{gifts}   // die $self." gifts not set"; }

sub packer($self, $packer=undef)  {
  return $self->{packer} = $packer if $packer;
  return $self->{packer} // die $self." packer not set";
}

1;
