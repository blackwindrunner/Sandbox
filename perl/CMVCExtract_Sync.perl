#!/usr/bin/perl
                                                                          
#-------------------------------------------------------------------------------------------------------
# Program: CMVCExtract_Sync.perl
# -------------------------
# This script will extract all the CMVC files for a given component and 
# store them into the specified directory. 
#
# Inputs:
# -------
#   1. component - the name of the component to be extracted.
#   2. release - the release that is being extracted.
#   3. path - the path where the extracted files are to be placed.
#   4. verbose - gives details of the command while the script is running
#   5. show - shows the flow but does not run all of the command.
#
# Outputs:
# --------
#   1. Extracted CMVC files
#
# Change history:
# ---------------
# ------------------------------------------------------------------------------------------------------

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
my $family="btt\@9\.123\.123\.194\@8765";
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

system("c:\\cmvcreset.bat");

#------------------------ lisa2 2008/07/28 --------------------------------------------------
#    extracts a level (full) from cmvc to the local filesystem using
#    the local cmvc extract archive/cache. if a cached committed
#    release is found, it is unarchived locally, otherwise it is
#    extracted via File -extract and saved into the
#    archive. finally, the level is extracted with the Level -map
#    command. when the cached copy is found this method can save many
#    minutes vs the full extract.
#--------------------------------------------------------------------------------------
#the folder which contains files
my $file_path = "$path\\$component";
print "\t\t\ rm -rf $file_path \n\n";
system("rm -rf $file_path");
print "\t\t test -d $file_path || mkdir $file_path \n\n";
system("test -d $file_path || mkdir $file_path");

#the folder which contains local cmvc extract archive/cache
my $commit_path_base = "D:\\composer811_base";
my $commit_path = "$commit_path_base\\$component";

#flag to signal if cache was out-of-date
my $CACHE_OUT_OF_DATE = 1;
#determines the cmvc last commit date of the release
my $MY_COMMITDATE = my_determine_commit_date($family, $release);

#there is a committed level
if ($MY_COMMITDATE ne "") {
  #determine if user specified level is older than the last committed level. If so, exit right now.
  #my $MY_LEVELDATE = my_determine_level_date($family, $release, $level);
 
  #if ($MY_LEVELDATE < $MY_COMMITDATE){
   # print "\t\tYour specified level $MY_LEVELDATE is older than last committed level $MY_COMMITDATE. exit! \n\n";
    #exit 1;
  #}
  
  #use local archive/cache
  if (-e $commit_path_base){
    #verify that the committed root dir exists, otherwise create it
    print "\t\t\ test -d $commit_path || mkdir $commit_path n\n";
    system("test -d $commit_path || mkdir $commit_path");
    
    #determine last committed archive file
    my $zip_name = `ls $commit_path\\ | tail -1`;
    chomp $zip_name;
    
    if (-f "$commit_path\\$zip_name") {
      
      #determine last committed timestamp
      my $MY_LAST_COMMITDATE = my_convert_timestamp ($zip_name);
      #print "DEBUG: MY_LAST_COMMITDATE: $MY_LAST_COMMITDATE";
      
      #decompress the last committed
      print "\t\t\ cd $file_path && unzip $commit_path\\$zip_name n\n";
      system ("cd $file_path && unzip $commit_path\\$zip_name");
      
      #get list of all committed level names that are newer than our timestamp
      my $cmd = "report -g levelview -family $family -wh \"releasename='$release' and state in ('commit','complete') and commitdate>'$MY_LAST_COMMITDATE' order by commitdate\" -sel \"name\"";
      print "\t$cmd\n"; 
      open(QUERY, "$cmd |");
      my @levels = <QUERY>;         
      close(QUERY);
  
      if (! @levels) {
        # cache was up-to-date
        $CACHE_OUT_OF_DATE = 0;
        print "\t No new committed levels \n";
      }else{
        #extract each one in turn
        my $MY_COMMITTED_LEVEL;
        foreach $MY_COMMITTED_LEVEL (@levels) { 
          chomp $MY_COMMITTED_LEVEL;
          #print "DEBUG: MY_COMMITTED_LEVEL: $MY_COMMITTED_LEVEL \n";
          ExtractPartsInLevel($family, $release, $MY_COMMITTED_LEVEL, $component); 
        }
      }
      
    }else{
      print "There is not local archieve/cache! \n";
      # do NOT use local archieve/cache
      GetCommittedFiles();
    }
    
    #check if cache was out of date and if so create the archive file
    if ($CACHE_OUT_OF_DATE == 1) {
      #create the archive file
      print "\t\t\ rm -rf $commit_path \n\n";
      system("rm -rf $commit_path");
      print "\t\t test -d $commit_path || mkdir $commit_path \n\n";
      system("test -d $commit_path || mkdir $commit_path");
      print "\t\t cd $file_path && zip -r $commit_path\\$MY_COMMITDATE * \n\n";
      system ("cd $file_path && zip -r $commit_path\\$MY_COMMITDATE * ");
      print "\t\t ******* zip all new files*******\n";
    }
    
    # since the above steps can take considerable time, recheck that commitdate is same
    my $MY_COMMITDATE_CHECK = my_determine_commit_date ($family, $release);
    if ($MY_COMMITDATE eq $MY_COMMITDATE_CHECK){
      print "\t\t tcommit date is matching \n\n";
    }else{
      print "\t\t commit date is NOT matching, exit! \n\n";
      exit 1;
    }
  }else{
    #need to uncomment it
    GetCommittedFiles();
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
         
#------------------------ Get all of the files -----------------------------------------
# Get a list of all the files for this component in CMVC that is not deleted
#---------------------------------------------------------------------------------------
sub GetCommittedFiles {
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
}
                 
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
  #hyj modify
  my $cmd = "Level -map $elevel -family $family -release $release"; # List all the parts in the level
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

#------------------------ lisa2 2008/07/28 --------------------------------------------------
#------------------------ my_convert_timestamp -----------------------------------------
# Convert timestamp style from $MY_YEAR/$MY_MONTH/$MY_DAY $MY_HOUR:$MY_MINUTES:$MY_SECONDS to $MY_YEAR$MY_MONTH$MY_DAY$MY_HOUR$MY_MINUTES$MY_SECONDS
#---------------------------------------------------------------------------------------
sub my_convert_timestamp {
  my $MY_TIMESTAMP = shift;
  my $MY_YEAR = `echo $MY_TIMESTAMP | cut -c 1-4`;
  chomp $MY_YEAR;
  my $MY_MONTH = `echo $MY_TIMESTAMP | cut -c 5-6`;
  chomp $MY_MONTH;
  my $MY_DAY = `echo $MY_TIMESTAMP | cut -c 7-8`;
  chomp $MY_DAY;
  my $MY_HOUR = `echo $MY_TIMESTAMP | cut -c 9-10`;
  chomp $MY_HOUR;
  my $MY_MINUTES = `echo $MY_TIMESTAMP | cut -c 11-12`;
  chomp $MY_MINUTES;
  my $MY_SECONDS = `echo $MY_TIMESTAMP | cut -c 13-14`;
  chomp $MY_SECONDS;
  my $MY_TIMESTAMP_NEW = "$MY_YEAR/$MY_MONTH/$MY_DAY $MY_HOUR:$MY_MINUTES:$MY_SECONDS";
  return ($MY_TIMESTAMP_NEW);
} # End my_convert_timestamp

#------------------------ lisa2 2008/07/28 --------------------------------------------------
#------------------------ my_determine_commit_date -----------------------------------------
# Get the last commit date in one release
#---------------------------------------------------------------------------------------
sub my_determine_commit_date {
  my $efamily = shift;
  my $erelease = shift;
  my $MY_COMMITDATE_SUB = `report -g levelview -family $efamily -wh \"releasename='$erelease' and state in ('commit','complete') order by commitdate\" -sel commitdate | tail -1 | tr -d '/ :'`;
  chomp $MY_COMMITDATE_SUB;
  return ($MY_COMMITDATE_SUB);
} # End my_determine_commit_date

#------------------------ lisa2 2008/07/28 --------------------------------------------------
#------------------------ my_determine_level_date -----------------------------------------
# determines the cmvc last update date of the level
#---------------------------------------------------------------------------------------
sub my_determine_level_date {
  my $efamily = shift;
  my $erelease = shift;
  my $elevel = shift;
  my $MY_LEVELDATE_SUB = `report -g levelview -family $efamily -wh \"releasename='$erelease' and name='$elevel'\" -sel lastupdate | tail -1 | tr -d '/ :'`;
  chomp $MY_LEVELDATE_SUB;
  return ($MY_LEVELDATE_SUB);
} # End my_determine_commit_date