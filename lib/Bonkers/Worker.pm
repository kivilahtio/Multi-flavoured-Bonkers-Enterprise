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

=head2 assemble

The Worker assembles the Cracker and has the Cracker at hand, ready for dispatch.

 @returns {Bonkers::Cracker}

=cut

sub assemble($self) {
  return $self->crackerAtHand( $self->_getNewCracker );
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

=head2 _getNewCracker

 @returns {Bonkers::Cracker} A random Cracker from the given colours and gifts,
                             or the next Cracker from a predetermined feed of Crackers.

=cut

sub _getNewCracker($self) {
  my $cracker;

  if ($self->feed) { #Crackers from a given test feed.
    $cracker = shift(@{$self->feed()});
    $logger->trace('Cracker from a feed: '.np($cracker)) if $logger->is_trace();
  }
  else {
    my $randColour = $self->colours()->[ rand(scalar(@{$self->colours})) ];
    my $randGift =   $self->gifts()->[   rand(scalar(@{$self->gifts})) ];
    $cracker = Bonkers::Cracker->new({colour => $randColour, gift => $randGift});
    $logger->trace('Cracker from the void: '.np($cracker)) if $logger->is_trace();
  }

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
