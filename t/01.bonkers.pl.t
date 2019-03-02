#!/usr/bin/env perl

use Bonkers::Pragmas;
my $logger = Bonkers::Logger->get();

use Test::Most tests => 2;

ok(my $resultYaml = runShell('perl -Ilib bin/bonkers.pl -c red -c blue -g dog -g fish -i 10'),
  "Given the Cracker factory simulation is ran");

use YAML;
my $yaml = YAML::Load($resultYaml) or die "$!";
ok($yaml,
  "Then the STDOUT of the simulation is a valid YAML report");

$logger->trace(p($yaml)) if $logger->is_trace();

done_testing();



sub runShell($cmd) {
  my $rv = `$cmd` or die "Failed to execute the perl script '$!'";

  if ($? == -1) {
    die "failed to execute: $!\n";
  }
  elsif ($? & 127) {
    die printf "child died with signal %d, %s coredump\n",
          ($? & 127),  ($? & 128) ? 'with' : 'without';
  }

  return $rv;
}
