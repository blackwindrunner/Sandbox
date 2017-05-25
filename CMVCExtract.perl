#!/usr/bin/perl
                                                                          
#-------------------------------------------------------------------------------------------------------
# Program: CMVCExtract.perl
# -------------------------
# This script will extract all the CMVC files for a given component and 
# store them into the specified directory. It will then extract all of the files for the component
# that are in the specified level.
#
# Inputs:
# -------
#   1. component - the name of the component to be extracted.
#   2. level - the level to do the final extract on
#   3. release - the release that is being extracted.
#   4. path - the path where the extracted files are to be placed.
#   5. verbose - gives details of the command while the script is running
#   6. show - shows the flow but does not run all of the command.
#
# Outputs:
# --------
#   1. Extracted CMVC files
#
# Change history:
# ---------------
# 10/04/2001 - DWJ - Script created.
# 06/30/2004 - lisa1 - enable the variable -p
# 09/10/2007 - LWH - 
#-------------------------------------------------------------------------------------------------------

use File::Copy;
use Sort::Fields;
use strict;
select(STDOUT); $| = 1; # flush after every write

print "\t=\>$0\n";
my $usage = $0;
$usage =~ s%.*/(\S+)%$1%;
$usage .= " -c CMVC_Component -l CMVC_Level -r Release -p Path [-verbose] [-showonly]\n";

my $release="composer811";
my $level;
my $path = "";

my $component;
my $verbose = 0;
my $showOnly;

my $delDate = "1";
my $family="btt\@9\.125\.15\.79\@8765";
my @fileNames;
my $fileName;
my $fullpath;

my $extractCount=0;
my $depricateCount=0;

# Looking for the parameters -f (the feature #), -v (verbose) and -s (showonly)
my $arg;
while ($arg = shift @ARGV) {
  if ($arg =~ m/-p/i) {
    $path = shift or usage();
  }  elsif ($arg =~ m/-r/i) {
    $release = shift or usage();
  }  elsif ($arg =~ m/-l/i) {
    $level = shift or usage();
  }  elsif ($arg =~ m/-c/i) {
    $component = shift or usage();
  }  elsif ($arg =~ m/-v/i) {
    $verbose = 1;
  } elsif ($arg =~ m/-s/i) {
    $showOnly = 1;
  }
}

if ($path eq "") {                        # lisa1
  $path = `echo %ENG_BUILD_SPACE%`;
  chomp $path;
  $path = $path . "\\" . $release;
}                                         # lisa1

print "\t\tPath to CMVC extracted files: $path\n\n";

#------------------------ Get all of the files -----------------------------------------
# Get a list of all the files for this component in CMVC that is not deleted
#---------------------------------------------------------------------------------------
system("c:\\cmvcreset.bat");
my $cmd = "Report -g FileView -family $family -where \"releaseName = '$release' and compName = '$component' and dropDate is null and VersionSID is not null order by pathName\" -select \"VersionSID,pathName,nuPathName\"";
print "\t$cmd\n"; #  if ($verbose or $showOnly);
open(QUERY, "$cmd |");
@fileNames = <QUERY>;         
close(QUERY);


# Now cycle through the files
my $aPathName;my $aVersionSID;my $anuPathName;

foreach $fileName (@fileNames) { 
  (my $sec,my $min,my $hour,my $mday,my $mon,my $year,my $wday,my $yday,my $isdst) = localtime(time);
  if ($hour < 10 ) { $hour = "0$hour" }
  if ($min < 10 ) { $min = "0$min" }
  if ($sec < 10 ) { $sec = "0$sec" }
  my $hms="$hour:$min:$sec";

  chomp($fileName);
  ($aVersionSID,$aPathName,$anuPathName) = split('\|', $fileName );
  $fullpath = $path . "\\";  # Build the path to extract to
  if ($anuPathName =~ m%$component\/%i) {
    print "\t\t=\>\[$hms\] IssueCmd (File -extract **No rename** ($aVersionSID) $aPathName)\n";
  }
  else {
    print "\t\t=\>\[$hms\] IssueCmd (File -extract **Rename** ($aVersionSID) $aPathName)\n";
    print "\t\t\tRename:\n\t\t\t$fullpath$aPathName\n";
    $fullpath = "$fullpath$component\\";
    print "\t\t\tTo:\n\t\t\t$fullpath$anuPathName\n";
  }
  my $deletePath = "$fullpath$aPathName";
  $deletePath =~ s%/%\\%g;
  if (-e $deletePath) {
    $cmd = "del $deletePath";
    print "\t\t\t$cmd\n"  if ($verbose or $showOnly);
    print "\t\t\tRelic version exists.\n\t\t\t$cmd\n";
    system($cmd);
  }
  if ($aVersionSID ne "") {                                     # RCS4
#    print "\t\t=\>IssueCmd (File -extract ($aVersionSID) $aPathName)\n\t\t     **$fullpath\n";
#    print "$hms:\n";
#    $cmd = "report -testServer";
#    system($cmd);
print("File -extract  $aPathName -family $family -release $release -version $aVersionSID -crlf -fmask 777 -relative $fullpath");
    IssueCmd("File -extract  $aPathName -family $family -release $release -version $aVersionSID -crlf -fmask 777 -relative $fullpath", 1);
    $extractCount++;
    print "\t\t\<=IssueCmd\n";
  }
  else {
# New code - do not extract files without a version number.  Files w/out version numbers 
# should only be extracted during the ExtractPartsInLevel section.  
# If they are not included in the Level tracks; then they are new files whose track is not
# yet in the integrate state. 
#
# Comment the two lines below and uncomment the 3rd and 4th line to perform the extract.
#
    my $nonActionCmd = "File \n\t\t\t-extract $aPathName \n\t\t\t-family $family \n\t\t\t-release $release \n\t\t\t-crlf \n\t\t\t-fmask 777 \n\t\t\t-relative $fullpath";
    print "\t\t\tFile noted but *NOT* extracted (potential extract command) -\n\t\t\t$nonActionCmd\n";
#    IssueCmd("File -extract  $aPathName -family $family -release $release -crlf -fmask 777 -relative $fullpath", 1);
#    $extractCount++;
    print "\t\t\<=IssueCmd (No version specified/available - NO extract)\n";
  }
}
my $fullResultsPath = $path . "\\" . $component . "\\bin\\";  # Build the path to extract to
if (!mkdir("$fullResultsPath")) {
} 
print "\tfilename = $fileName\n"   if ($verbose or $showOnly);    
#-------------------------------------------Get the files from the level ---------------------------
# Extract the files for this component that are in the level
#---------------------------------------------------------------------------------------------------
if ($level) {
  ExtractPartsInLevel($family, $release, $level, $component); 
  
}
close (LOGFILE);
print "\t\<=$0\n";
exit 0;
                          
 sub IssueCmd {
  my $cmd = shift;
  my $checkReturn = shift;
  print "\t$cmd\n"  if ($verbose or $showOnly);
  if (!$showOnly) {
    my $rc = system($cmd) >> 8;
    if ($checkReturn and $rc) {
      exit 12;
    } # end if checking the return
  } # end if not showonly
}  # end IssueCmd


sub ExtractPartsInLevel { # start ExtractPartsInLevel
  my $efamily = shift;
  my $erelease = shift;
  my $elevel = shift;
  my $ecomponent = shift;
  print "\t\t=\>ExtractPartsInLevel ($efamily, $erelease, $elevel, $ecomponent)\n";
  my $cmd = "Level -map $level -family $family -release $release"; # List all the parts in the level
  open(QUERY, "$cmd |");
  my @lines = <QUERY>;
  close(QUERY);

  my @slines;

  # Sort the files in the level by the change type in reverse order: rename,delta,delete,create
  my $sort_8 = make_fieldsort '\|', ['-8'], @lines;
  @slines = $sort_8->(@lines);

  my $line; my $aFileID; my $aReleaseName; my $aLevelName; my $aComponentName; my $aVersionSID; 
  my $aPathName; my $aOldPathName; my $aChangeType; my $aFileMode; my $aFileType; my $aVersionSize;
  my @alines;

  foreach $line (@slines) { # Get the information for each member of the level
    (my $sec,my $min,my $hour,my $mday,my $mon,my $year,my $wday,my $yday,my $isdst) = localtime(time);
    if ($hour < 10 ) { $hour = "0$hour" }
    if ($min < 10 ) { $min = "0$min" }
    if ($sec < 10 ) { $sec = "0$sec" }
    my $hms="$hour:$min:$sec";

    chomp($line);
    ($aFileID,$aReleaseName,$aLevelName,$aComponentName,$aVersionSID,$aPathName,$aOldPathName,$aChangeType,$aFileMode,$aFileType,$aVersionSize) = split('\|', $line);
    $fullpath = $path . "\\";  # Build the path to extract to
    if ($ecomponent eq $aComponentName)  {  # component based match so extract the file
      if (!($aPathName =~ m%$component\/%i)) {
        print "\t\t\tneed to move the file from\n\t\t\t$fullpath$aPathName\n";
        $fullpath = "$fullpath$component\\";
        print "\t\t\tto\n\t\t\t$fullpath$aPathName\n";
      }
      if ($aChangeType eq "delete")  {
        my $deletePath = "$fullpath$aPathName";
        $deletePath =~ s%/%\\%g;
        $cmd = "del $deletePath";
        print "\t\t\t$cmd\n"  if ($verbose or $showOnly);
        print "\t\t\tDelete: $aPathName\n";
        $extractCount--;
        $depricateCount++;
        system($cmd);
      }
      elsif ($aChangeType eq "rename")  {
        my $deletePath = "$fullpath$aOldPathName";
        $deletePath =~ s%/%\\%g;
        if (-e $deletePath) {
          $cmd = "del $deletePath";
          print "\t\t\t1$cmd\n"  if ($verbose or $showOnly);
          system($cmd);
        }
        $deletePath = "$fullpath$aPathName";
        $deletePath =~ s%/%\\%g;
        
        if (-e $deletePath) {
          $cmd = "del $deletePath";
          print "\t\t\t2$cmd\n"  if ($verbose or $showOnly);
          system($cmd);
        }
        print "\t\t\t=\>\[$hms\] IssueCmd (File -rename $aOldPathName to $aPathName)\n";
#        print "$hms:\n";
#        $cmd = "report -testServer";
        IssueCmd("File -extract  $aPathName -family $family -release $release -version $aVersionSID -relative $fullpath -crlf -fmask 777", 1);
        print "\t\t\t\<=IssueCmd\n";
      }
      else {
        my $deletePath = "$fullpath$aPathName";
        $deletePath =~ s%/%\\%g;
        if (-e $deletePath) {
          $cmd = "del $deletePath";
         $extractCount--;
          print "\t\t\t$cmd\n"  if ($verbose or $showOnly);
          system($cmd);
        }
        print "\t\t\t=\>\[$hms\] IssueCmd (File -extract ($aVersionSID) $aPathName)\n";
        IssueCmd("File -extract  $aPathName -family $family -release $release -version $aVersionSID -relative $fullpath -crlf -fmask 777 ", 1);
        $extractCount++;
        print "\t\t\t\<=IssueCmd\n";
      }
    }
  } 

  print "\n\n\t\t\tTotal Files extracted: $extractCount\n";
  print "\t\t\tTotal Files depricated: $depricateCount\n";
   
  print "\t\t\<=ExtractPartsInLevel\n";

} # End ExtractPartsInLevel
