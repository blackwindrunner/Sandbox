#!/usr/bin/perl
                                                                          
#-------------------------------------------------------------------------------------------------------
# Program: CompleteLevel.perl
# -------------------------
# This script will check wehether there ere some defects or features with Integrate state
#
# Inputs:
# -------
#   1. LevelName - the Level that is being extracted.
# Outputs:
# --------
#   1. Yes or No
#
# Change history:
# ---------------
# 11/20/2008 - huangyanjun - create
#-------------------------------------------------------------------------------------------------------

use File::Copy;
use Sort::Fields;
use strict;
select(STDOUT); $| = 1; # flush after every write
print "\t=\>$0\n";
my $usage = $0;
$usage =~ s%.*/(\S+)%$1%;
$usage .= " -l CMVC_Level -r Release\n";

my $release="composer811";
my $level;

my $family="btt\@9\.123\.123\.194\@8765";

# Looking for the parameters -f (the feature #), -v (verbose) and -s (showonly)
my $arg;
while ($arg = shift @ARGV) {
  if ($arg =~ m/-r/i) {
    $release = shift or usage();
  }  elsif ($arg =~ m/-l/i) {
    $level = shift or usage();
  } 
}
system("c:\\cmvcreset.bat");

CommitLevel($level, $release, $family);
CompleteLevel($level, $release, $family);
sub CommitLevel {
  my $LevelName = shift;
  my $Release = shift;
  my $Family = shift;
  my $Command;
  print "\tCommiting the level\n";
  $Command = "Level -commit $LevelName -family $Family -release $Release";
  system ($Command);
}

sub CompleteLevel {
  my $LevelName = shift;
  my $Release = shift;
  my $Family = shift;
  my $Command;
  print "\tCompleting the level\n";
  $Command = "Level -complete $LevelName -family $Family -release $Release";
  system ($Command);
}

