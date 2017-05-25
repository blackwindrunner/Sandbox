#!/usr/bin/perl -w

# Program: CreateLevel.perl
#
# This program will create a level using the traditional naming convention by
# using the present date. This program will automatically include all the tracks
# that are in the integrate state for all components of the release. This program
# will remove from the level all the tracks with pre-req's and co-req's.
# This program is called by build.bat.
#
# Change history:
#   2007/06/30 LiuWeiHua modified it, let it is called by build.bat.
#   2008/11/19 HuangYanJun modified if, let it create several build Level in one day.
#   2009/12/08 LiuJuan modified it, let it support more types of prefix for defect and feature.
     #if (($prefix eq "f") || ($prefix eq "s")) {       
      # $trackString = "-feature";                     # RCS1
    #} elsif (($prefix eq "d") ||($prefix eq "c") || ($prefix eq "IY")||($prefix eq "JR") ||($prefix eq "PQ")) {   
    #$trackString = "-defect";                       # lisa
      

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

usage () if ! defined $Release;
usage () if ! defined $Type;

if (!defined $LevelName) {
  $LevelName = GetLevelName();
}
print "\tThe build level is defined as: $LevelName\n";

my $LevelCommand;  # lwh Put level name to build_level.bat
#my $levelCurrent = chomp($LevelName);
$LevelCommand = "echo set level_serialbuild=$LevelName>D:\\composer8210\\SandBox\\build_level.bat"; #lwh
system ($LevelCommand); # lwh

my $RLevel = "";
my $RState = "";
my $TLevel = "";
my $TState = "";

system("c:\\cmvcreset.bat");

($RLevel, $RState) = CheckExistingLevel ($Release, "build");
($TLevel, $TState) = CheckExistingLevel ($Release, $LevelName);      

if((!defined ($RState)) && (!defined ($RLevel)) && (!defined ($TState)) && (!defined ($TLevel))) {
  $Case = 5;
}
elsif ((defined ($RState)) && ($RState eq "build") && ($RLevel eq $LevelName)){
  $Case = 1;
}
elsif ((defined ($RState)) && ($RState eq "build") && ($RLevel lt $LevelName) && (!defined($TLevel)) && (!defined($TState)) ){ # RCS2
  $Case = 2;
}
elsif ((defined ($RState)) && ($RState eq "build") && ($RLevel gt $LevelName) && (!defined($TLevel)) && (!defined($TState)) ){ # RCS2
  $Case = 6;                                               # RCS2
}                                                          # RCS2
elsif (($TState eq "integrate") && ($TLevel eq $LevelName)){
  $Case = 3;
}
elsif (($TState eq "working") && ($TLevel eq $LevelName)){
  $Case = 4;
}
elsif(($TState eq "commit") && ($TLevel eq $LevelName)){
  $Case = 6;
}
elsif(($TState eq "complete") && ($TLevel eq $LevelName)){
  $Case = 6;
}

SWITCH: {
  if ($Case == 1) {
    print "\tFound level in \"build\" state: $LevelName\n";
    AddLevelMember($LevelName, $Release, $Family, $integrationControl, @Tracks);
    NoLevelMember($LevelName) ? print "\t***** NO TRACKS TO ADD *****\n\n****Warning: No tracks to build\n" : print "\n\t    Level check is OK\n";
    BuildLevel($LevelName, $Release, $Family);
    if ($integrationControl) {PrintList();}
    last SWITCH;	  
  }

  if ($Case == 2) {
    print "\tCommitting previous level: $RLevel\n";
    CommitLevel($RLevel, $Release, $Family);
    CompleteLevel($RLevel, $Release, $Family);
    CreateLevel($LevelName, $Release, $Family, $Type);
    AddLevelMember($LevelName, $Release, $Family, $integrationControl, @Tracks);
    NoLevelMember($LevelName) ? print "\t***** NO TRACKS TO ADD *****\n\n****Warning: No tracks to build\n" : print "\n\t    Level check is OK\n";
    BuildLevel($LevelName, $Release, $Family);
    if ($integrationControl) {PrintList();}
    last SWITCH;
  }

  if ($Case == 3) {
    print "\tFound level in \"integrate\" state: $LevelName\n";
    AddLevelMember($LevelName, $Release, $Family, $integrationControl, @Tracks);
    NoLevelMember($LevelName) ? print "\t***** NO TRACKS TO ADD *****\n\n****Warning: No tracks to build\n" : print "\n\t    Level check is OK\n";
    BuildLevel($LevelName, $Release, $Family);
    if ($integrationControl) {PrintList();}
    last SWITCH;

  }
  if ($Case == 4) {
    print "\tFound level in \"working\" state: $LevelName\n";
    AddLevelMember($LevelName, $Release, $Family, $integrationControl, @Tracks);
    NoLevelMember($LevelName) ? print "\t***** NO TRACKS TO ADD *****\n\n****Warning: No tracks to build\n" : print "\n\t    Level check is OK\n";
    BuildLevel($LevelName, $Release, $Family);
    if ($integrationControl) {PrintList();}
    last SWITCH;

  }
  if ($Case == 5) {
    print "\tCreating new level: $LevelName\n";
    CreateLevel($LevelName, $Release, $Family, $Type);
    AddLevelMember($LevelName, $Release, $Family, $integrationControl, @Tracks);
    NoLevelMember($LevelName) ? print "\t***** NO TRACKS TO ADD *****\n\n****Warning: No tracks to build\n" : print "\n\t    Level check is OK\n";
    BuildLevel($LevelName, $Release, $Family);
    if ($integrationControl) {PrintList();}
    last SWITCH;

  }
  if ($Case == 6){
    print "\tThe default level is in \"commit\" or \"complete\" state\nGetting a new name ";
    ($LevelName, $TState) = GetNewName($LevelName, $Release);
    print "$LevelName\n";
    if (!defined $TState){CreateLevel($LevelName, $Release, $Family, $Type);}
    $LevelCommand = "echo set level_serialbuild=$LevelName>D:\\composer8210\\SandBox\\build_level.bat"; #hyj modify
    system ($LevelCommand);#hyj modify
    AddLevelMember($LevelName, $Release, $Family, $integrationControl, @Tracks);
    NoLevelMember($LevelName) ? print "\t***** NO TRACKS TO ADD *****\n\n
    ****Warning: No tracks to build\n" : print "\n\t    Level check is OK\n"; 
    BuildLevel($LevelName, $Release, $Family);
    if ($integrationControl) {PrintList();}
    last SWITCH;
  }
}

sub NoLevelMember{
  my $LevelName = shift;
  my ($Level, $State);
  ($Level, $State) = CheckExistingLevel ($Release, $LevelName);
  if($State  eq "working"){return 1;}
  else {return 0;}
}

sub GetNewName{
  my ($LevelName, $Release) = @ARG;
  my @ReturnValues;
  my @NameChars = split //, $LevelName;
  my $Present_tag = pop(@NameChars);
  my %Nametags = ('a' => 'b','b' => 'c','c' => 'd','d' => 'e','e' => 'f',  # RCS2
                  'f' => 'g','g' => 'h','h' => 'i','i' => 'j','j' => 'k',  # RCS2
                  'k' => 'l','l' => 'm','m' => 'n','n' => 'o','o' => 'p',  # RCS2
                  'p' => 'q','q' => 'r','r' => 's','s' => 't','t' => 'u',  # RCS2
                  'u' => 'v','v' => 'w','w' => 'x','x' => 'y','y' => 'z'); # RCS2
  my $Level = $LevelName;
  $Level =~ s%$Present_tag$%%;
  $LevelName = $Level.$Nametags{$Present_tag};
  my ($TLevel, $TState) = CheckExistingLevel ($Release, $LevelName);
  while ((defined ($TState)) && (($TState eq "commit") or ($TState eq "complete"))) {        
    $Level = $LevelName;
    @NameChars = ();
    @NameChars = split //, $LevelName;
    $Present_tag = pop(@NameChars);
    $Level =~ s%$Present_tag$%%;
    $LevelName = $Level.$Nametags{$Present_tag}; 
    ($TLevel, $TState) = CheckExistingLevel ($Release, $LevelName);
  }
  open(LVLFILE, ">../newlevel") or die "****Error: Cannot open newlevel file: $!\n"; # RCS2
  print LVLFILE "$LevelName" or die "****Error: Print failed\n";                     # RCS2
  close LVLFILE;                                                                     # RCS2
  @ReturnValues = ($LevelName, $TState);
  return @ReturnValues;
} 

sub CheckExistingLevel {
  my @LevelPerms = ();
  my $Level;                                               # RCS2
  my $SaveLevel = "";                                      # RCS2
  my $SaveState = "";                                      # RCS2
  my $Release = shift;
  my $Type;
  my $cmd;
  my $Line;
  my $StateOrName = shift;
  my ($Creator, $ADDDate, $ADDTime, $UpdateDate, $Updatetime, $State, $vars);
  if ($StateOrName eq "build"){
    $cmd = "Report -view levelView -family $Family -where \"releaseName=\'$Release\' AND state=\'$StateOrName\'\" > tempfile";
  }
  else {
    $cmd = "Report -view levelView -family $Family -where \"releaseName=\'$Release\' AND name=\'$StateOrName\'\" > tempfile";
  }
  
  system($cmd);
  print $cmd;
  open (TEMPFILE, "tempfile") || warn  or warn "$prg_name: Could not open file tempfile : $!\n";

  while ($Line = <TEMPFILE>){
    if ($Line =~ /^#/) { next;}    # skip comment
    if ($Line =~ /^\s*$/) { next;} # skip blank line
    if ($Line =~ m/^L/) {

      @LevelPerms = split  /\s+\s*/, $Line;
      

      $State = pop(@LevelPerms);
      my $Updatetime = pop(@LevelPerms);
      my $Updatedate = pop(@LevelPerms);
      if(($State eq "commit") or ($State eq "complete")){
        my $CommitTime = pop(@LevelPerms);
        my $CommitDate = pop(@LevelPerms);
      }
      $ADDTime = pop(@LevelPerms);
      $ADDDate =  pop(@LevelPerms);
      $Creator = pop(@LevelPerms);
      $Type = pop(@LevelPerms);
      $Release = pop(@LevelPerms);
      $Level = pop(@LevelPerms);                           # RCS2
      if ($Level eq $LevelName) {                          # RCS2
         $SaveLevel = $Level;                              # RCS2
         $SaveState = $State;                              # RCS2
         last;        # leave the loop                     # RCS2
      }  # end if                                          # RCS2
      else {                                               # RCS2
         if ($Level gt $LevelName) {                       # RCS2
            $SaveLevel = $Level;                           # RCS2
            $SaveState = $State;                           # RCS2
         }  # end if                                       # RCS2
      }  # end else                                        # RCS2
    }  # end if
  }  # end while
  close (TEMPFILE);
  if (-e "tempfile"){
    my $syscmd = "del tempfile";
    system ($syscmd);
  }
  if ($SaveLevel eq "") {                                  # RCS2
     undef $SaveLevel;                                     # RCS2
     undef $SaveState;                                     # RCS2
  }                                                        # RCS2
  return ($SaveLevel, $SaveState);                         # RCS2
}


sub GetLevelName{
  my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);
  ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);
  $year -= 100; # need to make at least two digits
  $year = sprintf "%2.2d", $year . "\n"; # and make sure it shows up as two characters
  ++$mon;
  $mon = sprintf "%2.2d", $mon . "\n";
  $mday = sprintf "%2.2d", $mday . "\n";
  my $cmvcLevel = "L" . $year . $mon . $mday . "a";
  return $cmvcLevel;
}

sub CreateLevel{
  my $LevelName = shift;
  my $Release = shift;
  my $Family = shift;
  my $Type = shift;
  my $Return;
  my $Command = "Level -create $LevelName -release $Release -family $Family  -type $Type -verbose";
  print $Command;
  print "\tCreating level in CMVC\n";
 
  $Return = system ($Command);
  if ($Return) {print "\t****Error: Level $LevelName creation failed\n";}
}
  
sub AddLevelMember{
  my $LevelName = shift;
  my $Release = shift;
  my $Family = shift;
  my $rcomp;                        # RCS1
  my $trackString;                  # RCS1
  my $trackString1;                  # RCS1
  my $number;
  my $prefix;
  my $defAbstract;

  print "\tLooking for integrated tracks\n";
  print "\tTracks Added -\n";
  print "\t    Tracks already in Release\/Level:$Release\/$LevelName:\n";
  print "\t\tPrefix  Number      Abstract\n\t\t------  ------      --------\n";

  my $cmd ="Report -raw -view LevelMemberView -family $Family -where \"levelName in ('$LevelName') and releaseName in ('$Release')\"";
  open(REPORT, "$cmd |") or warn and exit -1;
  print("**********$cmd***********\n");
  my @trackViewLines = <REPORT>;
  close(REPORT);

  foreach  my $line (@trackViewLines) {
    (my $lvl, my $rel, $number, my $jnk1) = split('\|', $line);
    $number =~ s/\n//g;                              # RCS1

    $cmd ="Report -g trackView -family $Family -where \"releaseName in '$Release' and defectName in '$number'\" -select \"defectPrefix, defectAbstract\"";
    open(REPORT, "$cmd |") or warn and exit -1;
    my @trkview = <REPORT>;
    close(REPORT);

    foreach  my $line1 (@trkview) {
      (my $prefix, $defAbstract) = split('\|', $line1);
      $prefix =~ s/\n//g;
      $defAbstract =~ s/\n//g;
      printf("\t\t%-8s%-12s%-80s\n", $prefix, $number, $defAbstract);
    }
  }

  print "\n\t    Tracks new to Release\/Level:$Release\/$LevelName:\n";
  print "\t\tPrefix  Number      Abstract\n\t\t------  ------      --------\n";
  $cmd = "Report -g TrackView -family $Family -where \"state='integrate' and releaseName='$Release' and actual is null\" -select \"defectName, defectPrefix, defectAbstract\"";
  open(REPORT, "$cmd |") or warn and exit -1;
  print("********$cmd**********");
  @trackViewLines = <REPORT>;
  close(REPORT);

  foreach  my $line (@trackViewLines) {
    ($number, $prefix, $defAbstract) = split('\|', $line);
    $prefix =~ s/\n//g;                              # RCS1
    $trackString = "";                               # RCS1
    $number =~ s/\n//g;                              # RCS1
    if (($prefix eq "f") || ($prefix eq "s")) {       
       $trackString = "-feature";                     # RCS1
    } elsif (($prefix eq "d") ||($prefix eq "c") || ($prefix eq "IY")||($prefix eq "JR") ||($prefix eq "PQ")) {                        # lisa
       $trackString = "-defect";                      # RCS1
    } else {                                          # lisa
       $trackString = "";
    }
 
    if ($trackString ne "") {                       # RCS1  
       $trackString = "$trackString $number";        # RCS1
       $cmd = "Levelmem -create -level $LevelName -release $Release -family $Family $trackString";
       my $rc = system($cmd);
       $rc ? print "****Warning: $trackString could not be added to level, $!\n" : print "$trackString added\n";     
  }  
}    

sub BuildLevel{
  my $LevelName = shift;
  my $Release = shift;
  my $Family = shift;
  my ($Command, $Return);
  my $retry = 0;                                      # RCS1
  print "\tBuilding the level\n";
  $Command = "Level -build $LevelName -family $Family -release $Release -verbose";
  $Return = system($Command);
  while ($Return){
    if ($retry++ > 2) {                                      # RCS1
      print "\t****Error: Trying to build level $LevelName\n"; # RCS1
      exit 1;                                                # RCS1
    }                                                        # RCS1
    if ($integrationControl) {
      print "\t****Error: Level problem, check integration control file\n";
      exit 1;
    }
    print "\tBuilding the level\n";
    $Command = "Level -build $LevelName -family $Family -release $Release -verbose";
    $Return = system($Command);
  }

}

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

sub PrintList{
  my $key;
  foreach $key ( keys %trackHash){
    if (!$trackHash{$key}){
	     print "\tcould not be built: $key, $trackHash{$key}\n";
	   }
	}
}
}