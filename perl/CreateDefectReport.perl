#!/usr/bin/perl
                                                                          
#-------------------------------------------------------------------------------------------------------
# Program: CreateDefectReport.perl
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

my $release="composer8103";
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

my $cmd ="Report -g ChangeView -family $family -where \"releaseName in '$release' and levelName in '$level'\" -select \"pathName, Defectname,defectType\"";
open(CHANGEVIEW, "$cmd |") or warn and exit -1;
my @changeView = <CHANGEVIEW>;
my $fileNum = @changeView;
#print("\n defect: $fileNum\n");  
my $pathName;
my $defectName; 
my $defectType;
my $oldComponent;
my $oldDefectName;
my $component;  
#sort the array
my @changeView1 = sort(@changeView);      
foreach my $line (@changeView1) {
    ($pathName, $defectName, $defectType) = split('\|', $line);
    $pathName =~ s/\n//g;
    $defectName =~ s/\n//g;
    $defectType =~ s/\n//g;
    $pathName =~ /(^[^\\]+?)\//;
    $component = $1;
    if (($component ne $oldComponent) or ($defectName ne $oldDefectName)) {
       printf("%-50s%-20s%-20s\n", $component, $defectType, $defectName);
       $oldComponent = $component;
       $oldDefectName = $defectName;
    }
 }
