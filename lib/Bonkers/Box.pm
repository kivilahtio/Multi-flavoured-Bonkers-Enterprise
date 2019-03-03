package Bonkers::Box;

use Bonkers::Pragmas;

use overload
  '""' => sub { ref($_[0]).":> { colour => '".$_[0]->colour."'}"; }
;

my $logger = Bonkers::Logger->get();

=head2 new

Instantiate a new Box.

 @param {HASHRef} of object properties:
    {
      colour => {String} MANDATORY,
    }

=cut

sub new($class, $params) {
  my $self = bless($params, $class);
  $self->{crackers} = {}; #Store the crackers by the gift, so we can easily lookup if the incoming gift already exists.
  return $self;
}

=head2 place

Place a Cracker into this Box.

 @param {Bonkers::Cracker} Cracker to put in
 @returns {Bonkers::Box} This Box
 @throws die if cannot place a Cracker in.

=cut

sub place($self, $cracker) {
  unless ($self->crackers->{ $cracker->gift }) {
    $cracker->box($self);
    $self->crackers->{ $cracker->gift } = $cracker;
  }
  else {
    die "Gift '".$cracker->gift."' already exists in the '".$self->colour."' box!";
  }

  $logger->trace(np($self)."\n".np($cracker)) if $logger->is_trace();
  return $self;
}

sub colour($self) { return $self->{colour} // die $self." colour not set"; }
sub crackers($self) { return $self->{crackers}; }

=head2 report

  @returns {ARRAYRef of Bonkers::Cracker->report()} Condensed representation of all the Crackers in this box.

=cut

sub report($self) {
  my @crackers = map {$_->report()}
                 map {$self->crackers->{$_}}
                 sort keys %{$self->crackers()};
  return \@crackers;
}

1;
