#!/usr/local/bin/perl -w

# Program: defect_info.perl
# This program used to save the defect information of every level.
# Change history:
#   2008/7/17 lwh created it used by build_bvt.bat.


use strict;

use English;        # Allow use of English names for special variables
use File::Basename;
my ($prg_name, $prg_path) = fileparse($PROGRAM_NAME);
my $integrationControl = 0;
my $arg;
my $Type;
my $Case;
my @Tracks;
my $Component;
my $Release;
my %trackHash =();
my @Comp = ();
my $LevelName;
my $Family = "btt\@9.123.123.194\@8765";

sub usage {
  my $usage = "Usage: $prg_name -r release -c component -t integration/development [-l levelName]";
  print $usage, "\n";
  exit 1;
}


@ARGV = ('-') unless @ARGV;
while ($ARGV = shift ) {
  if ($ARGV =~ m/-r/i) {
    $Release = shift or usage();
  } elsif ($ARGV =~ m/-l/i) {
    $LevelName = shift or usage();
  } elsif ($ARGV =~ m/-t/i) {
    $Type = shift or usage();  
  } elsif ($ARGV =~ m/-c/i) {
    $Component = shift or usage();
  }  
}


my $cmd ="Report -raw -view LevelMemberView -family $Family -where \"levelName in ('$LevelName') and releaseName in ('$Release')\"";
  open(REPORT, "$cmd |") or warn and exit -1;
  print("**********$cmd***********\n");
  my @trackViewLines = <REPORT>;
  close(REPORT);


