#!/usr/bin/env perl

no warnings qw(experimental::signatures);
use Bonkers::Pragmas;

use Test::Most;

use Bonkers::Cracker;
use Bonkers::Worker;
use Bonkers::Packer;


subtest "Feature: Bonkers crackers travel the conveyer belt to color-themed boxes", sub {
  plan tests => 30;

  my @colours = qw(red yellow green blue);
  my @gifts = qw(camel dog elephant frog);
  my @crackersFeed = (
    #These go directly to the rainbow box
    Bonkers::Cracker->new({colour => $colours[0], gift => $gifts[3]}),
    Bonkers::Cracker->new({colour => $colours[1], gift => $gifts[2]}),
    Bonkers::Cracker->new({colour => $colours[2], gift => $gifts[1]}),
    Bonkers::Cracker->new({colour => $colours[3], gift => $gifts[0]}),
    #these go directly to colour-boxes
    Bonkers::Cracker->new({colour => $colours[0], gift => $gifts[0]}),
    Bonkers::Cracker->new({colour => $colours[1], gift => $gifts[1]}),
    Bonkers::Cracker->new({colour => $colours[2], gift => $gifts[2]}),
    Bonkers::Cracker->new({colour => $colours[3], gift => $gifts[3]}),
    #As these are the exact same as that was put to colour boxes
    #they get discarded by gift
    Bonkers::Cracker->new({colour => $colours[0], gift => $gifts[0]}),
    Bonkers::Cracker->new({colour => $colours[1], gift => $gifts[1]}),
    Bonkers::Cracker->new({colour => $colours[2], gift => $gifts[2]}),
    Bonkers::Cracker->new({colour => $colours[3], gift => $gifts[3]}),
    #Fill a new round
    Bonkers::Cracker->new({colour => $colours[0], gift => $gifts[1]}),
    Bonkers::Cracker->new({colour => $colours[1], gift => $gifts[2]}),
    Bonkers::Cracker->new({colour => $colours[2], gift => $gifts[3]}),
    Bonkers::Cracker->new({colour => $colours[3], gift => $gifts[0]}),
    #Fill a new round
    Bonkers::Cracker->new({colour => $colours[0], gift => $gifts[2]}),
    Bonkers::Cracker->new({colour => $colours[1], gift => $gifts[3]}),
    Bonkers::Cracker->new({colour => $colours[2], gift => $gifts[0]}),
    Bonkers::Cracker->new({colour => $colours[3], gift => $gifts[1]}),
    #Fill a new round
    Bonkers::Cracker->new({colour => $colours[0], gift => $gifts[3]}),
    Bonkers::Cracker->new({colour => $colours[1], gift => $gifts[0]}),
    Bonkers::Cracker->new({colour => $colours[2], gift => $gifts[1]}),
    Bonkers::Cracker->new({colour => $colours[3], gift => $gifts[2]}),
    #Now all the boxes are full
    #No more room in the colour boxes
    Bonkers::Cracker->new({colour => $colours[0], gift => $gifts[3]}),
    Bonkers::Cracker->new({colour => $colours[1], gift => $gifts[0]}),
    Bonkers::Cracker->new({colour => $colours[2], gift => $gifts[1]}),
    Bonkers::Cracker->new({colour => $colours[3], gift => $gifts[2]}),
  );

  ok(my $worker = Bonkers::Worker->new({colours => \@colours, gifts => \@gifts, feed => Storable::dclone(\@crackersFeed)}),
    "Given a worker, producing crackers in colours '@colours' and gifts '@gifts'");

  ok(my $packer = Bonkers::Packer->new({colours => \@colours, worker => $worker}),
    "Given a packer, receiving '@colours' crackers from the worker");

  packCracker($worker, $packer, $crackersFeed[0],  'rainbow',  undef);
  packCracker($worker, $packer, $crackersFeed[1],  'rainbow',  undef);
  packCracker($worker, $packer, $crackersFeed[2],  'rainbow',  undef);
  packCracker($worker, $packer, $crackersFeed[3],  'rainbow',  undef);
  packCracker($worker, $packer, $crackersFeed[4],  'red',      undef);
  packCracker($worker, $packer, $crackersFeed[5],  'yellow',   undef);
  packCracker($worker, $packer, $crackersFeed[6],  'green',    undef);
  packCracker($worker, $packer, $crackersFeed[7],  'blue',     undef);
  packCracker($worker, $packer, $crackersFeed[8],   undef,    'Gift');
  packCracker($worker, $packer, $crackersFeed[9],   undef,    'Gift');
  packCracker($worker, $packer, $crackersFeed[10],  undef,    'Gift');
  packCracker($worker, $packer, $crackersFeed[11],  undef,    'Gift');
  packCracker($worker, $packer, $crackersFeed[12], 'red',      undef);
  packCracker($worker, $packer, $crackersFeed[13], 'yellow',   undef);
  packCracker($worker, $packer, $crackersFeed[14], 'green',    undef);
  packCracker($worker, $packer, $crackersFeed[15], 'blue',     undef);
  packCracker($worker, $packer, $crackersFeed[16], 'red',      undef);
  packCracker($worker, $packer, $crackersFeed[17], 'yellow',   undef);
  packCracker($worker, $packer, $crackersFeed[18], 'green',    undef);
  packCracker($worker, $packer, $crackersFeed[19], 'blue',     undef);
  packCracker($worker, $packer, $crackersFeed[20], 'red',      undef);
  packCracker($worker, $packer, $crackersFeed[21], 'yellow',   undef);
  packCracker($worker, $packer, $crackersFeed[22], 'green',    undef);
  packCracker($worker, $packer, $crackersFeed[23], 'blue',     undef);
  packCracker($worker, $packer, $crackersFeed[24],  undef,    'Gift');
  packCracker($worker, $packer, $crackersFeed[25],  undef,    'Gift');
  packCracker($worker, $packer, $crackersFeed[26],  undef,    'Gift');
  packCracker($worker, $packer, $crackersFeed[27],  undef,    'Gift');

};

sub packCracker($worker, $packer, $expectedCracker, $expectedBoxColour, $discardReason) {
  subtest "Packing Cracker ".$expectedCracker->colour."-".$expectedCracker->gift, sub {
    plan tests => 7;

    ok(my $cracker = $worker->assemble(),
      "When the worker has assembled a cracker");

    cmp_deeply($cracker, $expectedCracker,
      "Then the expected cracker is created");

    ok($worker->dispatch(), #Worker dispatches whatever he's got on his hands
      "when the worker dispatches the cracker");

    cmp_deeply($packer->crackerAtHand(), $expectedCracker,
      "Then the packer has the expected cracker");

    my $box;
    eval {
      $box = $packer->place(); #This throws an exception on failure.

      ok($box, #Packer packs the first thing he's got
        "When the packer has packed the cracker");

      cmp_deeply($box, isa('Bonkers::Box'),
        "Then the packer went into a box");

      is($box->colour(), $expectedBoxColour,
        "And the cracker was packed to the '$expectedBoxColour' box");
    };
    if ($@ && not($discardReason)) { #This is a real program exception
      die $@;
    }
    if ($@) {

      ok(1,
        "When the packer has packed the cracker");

      is($box, $expectedBoxColour,
        "Then the cracker is discarded");

      like($@, qr/^\Q$discardReason\E/,
        "And the discard reason was '$discardReason'");
    }
  };
}

done_testing;
