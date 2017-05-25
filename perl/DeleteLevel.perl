#!/usr/bin/perl -w

# Program: DeleteLevel.perl
#
# This program will delete a level in "build" state if this build is failed
# 
#
# Change history:
#   2009/10/27 LiuJuan created it, it will delete the current level which is build failed.
#   

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

# Level -integrate L091027b -family btt@9.123.123.194@8765 -release composer811 -verbose
#Level -delete L091027b -release composer811 -family btt@9.123.123.194@8765 -verbose
sub usage {
  my $usage = "Usage: $prg_name -r release";
  print $usage, "\n";
  exit 1;
}


@ARGV = ('-') unless @ARGV;
while ($ARGV = shift ) {
  if ($ARGV =~ m/-r/i) {
    $Release = shift or usage();
  } 
}

usage () if ! defined $Release;

open(LF, "D:/$Release/SandBox/build_level.bat") or die "****Error: Cannot open file: D:/$Release/SandBox/build_level.bat\n"; # RCS2
my $LevelName=<LF>;                     # RCS2
close LF; 
$LevelName=substr($LevelName, 22, 29);

#change the build state to integrate state for the level
my $Level_Command="";
$Level_Command="Level -integrate $LevelName -family $Family -release $Release -verbose";
system ($Level_Command);
print "\n$Level_Command success!\n";

#delete the level
$Level_Command="Level -delete $LevelName -family $Family -release $Release -verbose";
system ($Level_Command);
print "\n$Level_Command success!\n";

