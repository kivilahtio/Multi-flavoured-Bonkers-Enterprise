#!/usr/bin/env perl

no warnings qw(experimental::signatures);
use Bonkers::Pragmas;

use Bonkers;

my $logger = Bonkers::Logger->get();

use Getopt::Long;

use IO::Prompter {
  prompt_password => [-timeout=>120, -echo=>'*'],
  prompt_string   => [-timeout=>120],
  prompt_integer  => [-timeout=>120, -integer],
};


my %args;
Getopt::Long::GetOptions(
  'c|colour:s@'            => \$args{colours},
  'g|gift:s@'              => \$args{gifts},
  'i|crackers:i'           => \$args{crackers},
  'version'                => sub { Getopt::Long::VersionMessage() },
  'h|help'                 => sub {
  print <<HELP;

NAME
  $0 - Pack the Crackers

SYNOPSIS
  Does a Cracker packing conveyer belt test run with the given product parameters.

PARAMETERS

  -c --colour Repeateable Strings.
        The colours of Crackers.

  -g --gift Repeatable Strings.
        The types of gifts hidden inside the Crackers.

  -i --crackers Integer
        How many Crackers to produce before stopping the simulation?
        0 causes an Crackers to me manufactured until SIGINT (Ctrl-C) is given.

  -v level
        Verbose output to the STDOUT,

  --version
        Print version info

  -h --help
        Print this help.

HELP

  exit 0;
},
) or die("Error in command line arguments: $! $@"); #EO Getopt::Long::GetOptions()

unless ($args{colours}) {
  $args{colours}     = prompt_string("Please pass a list of colours for the Cracker factory production line:").'';
  $args{colours} = \@{[split(/\W+/, $args{colours})]};
}

unless ($args{gifts}) {
  $args{gifts}     = prompt_string("Please pass a list of gifts for the Cracker factory production line:").'';
  $args{gifts} = \@{[split(/\W+/, $args{gifts})]};
}

unless (defined $args{crackers}) {
  $args{crackers} = prompt_integer("Please tell me how many Crackers to manufacture. Enter 0 to enter the infinite loop!:")+0;
}
$args{crackers} = undef if ($args{crackers} == 0);

my $bonkers = Bonkers->new(\%args);
$bonkers->bonkThemAway();

print $bonkers->asYaml();
