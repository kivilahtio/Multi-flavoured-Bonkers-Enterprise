package Bonkers::Mixin::HasCracker;

use Bonkers::Pragmas;

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
