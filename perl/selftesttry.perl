use File::Copy;
use Sort::Fields;
use HTTP::Date;
use strict;
select(STDOUT); $| = 1; # flush after every write

print "\t=\>$0\n";
my $usage = $0;
$usage =~ s%.*/(\S+)%$1%;
$usage .= " -c CMVC_Component -l CMVC_Level -r Release -p Path [-verbose] [-showonly]\n";

my $release="composer811";
my $level="L121216a";
my $path = "";

my $component;
my $verbose = 0;
my $showOnly;

my $delDate = "1";
my $family="btt\@9\.123\.123\.194\@8765";
my @fileNames;
my $fileName;
my $fullpath;
my $ecomponent ="BTTToolsXUIEditor";
my $extractCount=0;
my $depricateCount=0;


print "\t\tPath to CMVC extracted files: $path\n\n";

system("c:\\cmvcreset.bat");



my $cmd = "Level -map $level -family $family -release $release"; # List all the parts in the level
print "$cmd";
open(QUERY, "$cmd |");
my @lines = <QUERY>;
close(QUERY);

my $num = @lines;
print "num:  $num";

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
 #       print "\t\t\t=\>\[$hms\] IssueCmd (File -rename $aOldPathName to $aPathName)\n";
#        print "$hms:\n";
#        $cmd = "report -testServer";
       # IssueCmd("File -extract  $aPathName -family $family -release $release -version $aVersionSID -relative $fullpath -crlf -fmask 777", 1);
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
        #IssueCmd("File -extract  $aPathName -family $family -release $release -version $aVersionSID -relative $fullpath -crlf -fmask 777 ", 1);
        $extractCount++;
        print "\t\t\t\<=IssueCmd\n";
      }
    }
  } 

  print "\n\n\t\t\tTotal Files extracted: $extractCount\n";
  print "\t\t\tTotal Files depricated: $depricateCount\n";
   
  print "\t\t\<=ExtractPartsInLevel\n";


perl -S D:\composer700\SandBox\perl\CMVCExtract.perl -r composer700 -c BTTToolsAppWizard -l L081218a -p D:\composer700 >>D:\\composer700\\SandBox\\AllBuildLogs\\cmvcextract1.log

