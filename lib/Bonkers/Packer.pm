package Bonkers::Packer;

use Bonkers::Pragmas;
use Bonkers::Box;
use Bonkers::Box::Rainbow;

use Bonkers::Mixin::HasCracker;
use parent 'Bonkers::Mixin::HasCracker';

my $logger = Bonkers::Logger->get();

sub new($class, $params) {
  $logger->trace(np($params)) if $logger->is_trace();

  my $self = bless($params, $class);

  $self->worker->packer($self);
  weaken($self->{worker}); #Break circular reference

  my %boxes = (rainbow => Bonkers::Box::Rainbow->new());
  foreach my $colour (@{$self->colours()}) {
    $boxes{$colour} = Bonkers::Box->new({colour => $colour});
  }
  $self->{boxes} = \%boxes;

  return $self;
}

=head2 place

Place a Cracker into one of the available Boxes.

Checks the rainbow-box first, and then boxes by colour.

 @param {Bonkers::Cracker} Cracker to put to any Box this Packer knows of
 @returns {Bonkers::Box} The Box the Cracker was put to
 @dies if no matching Box was found

=cut

sub place($self) {
  my $cracker = $self->crackerAtHand() or die "Packer is missing a Cracker?";
  $self->crackerAtHand(0);

  $logger->trace(np($cracker)) if $logger->is_trace();

  #Try to pack the rainbow-box first
  eval {
    $self->box('rainbow')->place($cracker);
  };
  if ($@ && $@ !~ /^(?:Gift|Colour)/) { #A very rudimentary exception system. Given more time Exeption::Class and Try::Tiny would step in.
    die $@; #We are not prepared to handle this exception.
  }

  #Rainbow-box didn't accept our cracker, try by colour instead.
  unless ($cracker->box()) {
    my $box = $self->box($cracker->colour);
    die "Box is missing for colour '".$cracker->colour."'" unless $box;

    $box->place($cracker); # Don't catch exceptions now. Let them bubble.
  }
}

sub box($self, $colour) { return $self->{boxes}->{$colour}; } #This way we can abstract away the internal data structure of boxes.
sub boxes($self)   { return $self->{boxes}   // die $self." boxes not set"; }

=head2 boxesList

 @returns {ARRAYRef of Bonkers::Box} Sorted by colour

=cut

sub boxesList($self) {
  my @boxes = map {$self->{boxes}->{$_}} sort keys %{$self->{boxes}};
  return \@boxes;
}

sub colours($self) { return $self->{colours} // die $self." colours not set"; }
sub worker($self)  { return $self->{worker}  // die $self." worker not set"; }

1;
