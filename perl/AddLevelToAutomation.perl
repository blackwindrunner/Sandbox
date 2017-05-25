#!/usr/bin/perl -w

# Program: AddLevelToAutomation.perl
#
#   2009/03/30 LiuJuan added, to add build level to BTTAutomation

use strict;

use English;        # Allow use of English names for special variables
use File::Basename;

open(LF, "D:/composer8210/SandBox/build_level.bat") or die "****Error: Cannot open file: D:/composer8210/SandBox/build_level.bat\n"; # RCS2
  my $level=<LF>;                     # RCS2
  close LF; 
$level=substr($level, 4, 29);

open(OF, '>D:/composer8210/BTTAutomation/buildlevel.properties') or die "can't create file:D:/composer8210/BTTAutomation/buildlevel.properties";
print OF ($level);
print "AddLevelToAutomation.perl-> add level number $level ";
close OF;
        
  