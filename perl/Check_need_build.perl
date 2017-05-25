#!/usr/bin/perl
                                                                          
#-------------------------------------------------------------------------------------------------------
# Program: Check_need_build.perl
# -------------------------
# This script will check wehether there ere some defects or features with Integrate state
#
# Inputs:
# -------
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
my $Family = "btt\@9.123.123.194\@8765";
system("c:\\cmvcreset.bat");


my $cmd = "report  -g trackview -family $Family -where \"state='integrate'AND releasename='composer8210' and id not in (select trackid from levelmembers)\""; 
$cmd = "report  -g trackview -family $Family -where \"state='integrate'AND releasename='composer8210' \""; 
print "\t$cmd\n"; 
open(QUERY, "$cmd |");

my @tracks = <QUERY>;         
close(QUERY);
my $need_build;
if (! @tracks) {
   print "\t No new integreted features or defects \n";
   $need_build="No";
}else{
   my $tracksNum = @tracks;
   print "\t Has new integreted features or defects $tracksNum \n";
   $need_build="Yes";
}
my $NeedBuildCommand = "echo set Need_Build=$need_build>D:\\composer8210\\SandBox\\need_build.bat"; 
system ($NeedBuildCommand);

