package Bonkers::Mixin::HasCracker;

use Bonkers::Pragmas;

=head1 SYNOPSIS

Is it a subclass?
Is it an interface?
No!
It is the MIXIN!

Whether or not it should be alive, is another discussion.

=cut

my $logger = Bonkers::Logger->get();

sub crackerAtHand($self, $cracker=undef) {
  if ($cracker) {
    $self->{crackerAtHand} = $cracker;
  }
  elsif (defined($cracker)) {
    $self->{crackerAtHand} = undef;
  }
  return $self->{crackerAtHand};
}

1;
