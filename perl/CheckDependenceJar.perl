#!/usr/bin/perl
                                                                          
#-------------------------------------------------------------------------------------------------------
# Program: CheckDependenceJar.perl
# -------------------------
# This script will check the correctness for component.properties of component 
# 
#
# Inputs:
# -------
#   1. release - the release that is being extracted.
#   2. component - the name of the component to be extracted.
#   3. path - the path where the extracted files are to be placed.
#
# Outputs:
# --------
#   1. checkDependenceJar.log
#
# Change history:
# ---------------
# 11/14/2008 - Yan Jun Huang - Script created.
#-------------------------------------------------------------------------------------------------------

use File::Copy;
use Sort::Fields;
use strict;
select(STDOUT); $| = 1; # flush after every write

print "\t=\>$0\n";
my $usage = $0;
$usage =~ s%.*/(\S+)%$1%;
$usage .= " -c  -r Release -c Component -p Path\n";

my $release="composer811";
my $path = "";

my $component;

my @fileNames;
my $fileName;
my $fullpath;
my @array;
my @jars;
my $iCount;
my $jCount;
my $pathjar;

my $arg;
while ($arg = shift @ARGV) {
  if ($arg =~ m/-p/i) {
    $path = shift or usage();
  }  elsif ($arg =~ m/-r/i) {
    $release = shift or usage();
  }  elsif ($arg =~ m/-c/i) {
    $component = shift or usage();
  }  
}

if ($path eq "") {                        # lisa1
  $path = `echo %ENG_BUILD_SPACE%`;
  chomp $path;  
  $path = $path . "\\" . $release;
}                                         # lisa1


#the folder which contains files
my $file_path = "$path\\$component";
print "\n\t\t=============== $path\\$component ==============\n\n";
system("test -d $file_path");

if (-f "$file_path\\component.properties") {
    #read coponent.properties
    if (open(MYFILE, "$file_path\\component.properties")) {
		@array = <MYFILE>;
		$iCount = 1;
        
		while ($iCount <= @array) {
			if ($array[$iCount-1] =~ /classpath/) {
	      #trim the 'classpath=' firstly
                         
				@jars = split(/;/, $array[$iCount-1]);
				$jCount = 1;
				my $length = @jars; 
				print "The jars length: $length\n";
				chomp(@jars);
				while ($jCount < @jars) {
					if ($jars[$jCount] !~ /ENG_WORK_SPACE/) {
					            $pathjar = $jars[$jCount];
					                               
                      if ($jars[$jCount] =~ /WAS_HOME/) {
                          $pathjar =~ s/\${WAS_HOME}/D:\\WebSphere61017\\AppServer/g;
				              } elsif ($jars[$jCount] =~ /RAD_HOME/) {
                          $pathjar =~ s/\${RAD_HOME}/D:\\SDP7007/g;
                      } else {
				        			    $pathjar =~ s/\${RAD_SHARED_HOME}/D:\\SDP7007Shared/g;
                      }
                      #print "$pathjar\n";
                      if (-f "$pathjar") {
							           print "\t\t $jars[$jCount]  \t\t\tis exist!!!\n";
						          } else {
                         print "\t\t $jars[$jCount]  \t\t\t is NOT exist*******\n";
							        }
		
					}
					$jCount = $jCount+1;
					
				}
		       	
      }
      $iCount++;	
     }

   }
   
}

      
      