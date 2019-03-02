package Bonkers;

use Bonkers::Pragmas;

use Bonkers::Cracker;
use Bonkers::Worker;
use Bonkers::Packer;

my $logger = Bonkers::Logger->get();

sub new($class, $parameters) {
  $logger->trace(np($parameters)) if $logger->is_trace();
  my $self = bless(Storable::dclone($parameters), $class);
  $self->{history} = [];

  die "There must be an equal amount of given parameters 'gifts' and 'colours'.".
      "Currently you gave '".scalar(@{$self->{gifts}})."' gifts and ".
      "'".scalar(@{$self->{colours}})."' colours!"
      unless (scalar(@{$self->{colours}}) == scalar(@{$self->{gifts}}));

  unless ($self->{crackers}) {
    $logger->warn("Unlimited amount of crackers is being simulated. To escape the simulation, press Ctrl-C. Signal INT (Sigint) [2] safely trapped.") if $logger->is_warn();

    my $prevSigINTHandler = $SIG{'INT'}; # Make sure we don't overload somebody elses trapper.
    $SIG{'INT'} = sub {
      $self->{_exitSimulation} = 1;
      $logger->info("Sig INT received. Terminating simulation.");
      if ($prevSigINTHandler) {
        $logger->info("Triggering other Sig INT handlers.");
        $prevSigINTHandler->();
      }
    };
  }

  return $self;
}

sub bonkThemAway($self) {
  $self->{worker} = Bonkers::Worker->new({colours => $self->{colours}, gifts => $self->{gifts}});
  $self->{packer} = Bonkers::Packer->new({colours => $self->{colours}, worker => $self->{worker}});

  while (1) { #Task assignment says, "The conveyer belt should be capable of delivering an infinite number of crackers"
    my $cracker = $self->{worker}->assemble();
    $self->{worker}->dispatch();

    eval {$self->{packer}->place();}; #This throws an exception on failure.

    $self->addCrackerToHistory($cracker, $@);

    last if (
      $self->{_exitSimulation} || # Escape if the kill switch is received.
      (
        defined($self->{crackers}) && $self->{crackers}-- <= 0 # If a specific number of crackers was requested, terminate when they run out.
      )
    );
  }

  return $self;
}

sub addCrackerToHistory($self, $cracker, $exception=undef) {
  if ($exception) {
    if ($exception =~ /^Colour/) {
      $cracker->status('Colour blocked');
    }
    elsif ($exception =~ /^Gift/) {
      $cracker->status('Gift blocked');
    }
    elsif ($exception =~ /^Box/) {
      $cracker->status('Box missing');
    }
    else {
      die $exception;
    }
  }
  else {
    $cracker->status("Placed to '".$cracker->box->colour."'");
  }

  push(@{$self->{history}}, $cracker);

  $logger->trace(np($cracker)) if $logger->is_trace();

  return $self;
}

=head2 asYaml

 @returns {YAML String} The report of the factory producting test run.

=cut

sub asYaml($self) {
  require YAML; #Lazy load exporter on demand

  my $report = {boxes => {}, crackers => {}};

  foreach my $box (@{$self->{packer}->boxesList}) {
    $report->{boxes}->{$box->colour} = {crackers => $box->report};
  }
  my @crackerReport = map {$_->report()} @{$self->{history}};
  $report->{crackers} = \@crackerReport;
  $report->{'crackers processed'} = scalar(@crackerReport);

  return YAML::Dump($report);
}

1;
