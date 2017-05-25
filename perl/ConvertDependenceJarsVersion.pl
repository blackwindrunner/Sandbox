#!/usr/bin/perl -w

#-------------------------------------------------------------------------------------------------------
# Program: ConvertDependenceJarsVersion.perl
# -------------------------
# This script will check the correctness for component.properties of component, convert the old version to latest version in RAD/WAS directory
# For example: perl ConvertDependenceJarsVersion.pl -f D:\composer811\BTTChannels\component.properties -r D:\RAD8\RADSE -s D:\RAD8\SDPShared -w F:\WAS7\AppServer
#
# Inputs:
# -------
#   1. component.properties - the file need to be updated.
#   2. RAD home
#   3. RAD Shared home
#   4. WAS home
#
# Outputs:
# --------
#   1. component.properties.update- the updated flies
#   2. ConvertDependenceJarsVersion.log - the update log
#
# Change history:
# ---------------
# 12/22/2010 - Liu Juan - Script created.
#-------------------------------------------------------------------------------------------------------

use File::Copy;
use Sort::Fields;
use strict;
use warnings;
select(STDOUT); $| = 1; # flush after every write

#print "\t=\>$0\n";
#my $usage = $0;
#$usage =~ s%.*/(\S+)%$1%;
#$usage .= "  -f component.properties -r RADHome -s RADShareHome -w WASHome\n";
use strict;
use warnings;

my $prg_name="ConvertDependenceJarsVersion.pl";
my $Release=$ARGV[0];
die "Usage:\nperl ConvertDependenceJarsVersion.pl \-f D\:\\composer811\\BTTChannels\\component.properties \-r D\:\\RAD8\\RADSE \-s D\:\\RAD8\\SDPShared \-w F\:\\WAS7\\AppServer" if (@ARGV <2);


my $infile="";
my $RADHome="";
my $RADShareHome="";
my $WASHome="";

my $WASWord="\$\{WAS\_HOME\}";
my $RADWord="\$\{RAD\_HOME\}";
my $RADShareWord="\$\{RAD\_SHARED\_HOME\}";

my $outFile="";
my $logFile="";

my $arg;
while ($arg = shift @ARGV) {
  if ($arg =~ m/-f/i) {
    $infile = shift ;
    #print ("$infile\n");
  }  elsif ($arg =~ m/-r/i) {
    $RADHome = shift ;
  }  elsif ($arg =~ m/-s/i) {
    $RADShareHome = shift;
  }  elsif ($arg =~ m/-w/i) {
    $WASHome = shift ;
  }
}

$outFile=$infile."\.out";
$logFile=$infile."\.log";


open(LOGF, ">$logFile") or die "can't create file:$logFile";
print LOGF ("#\n");
open(OUT, ">$outFile") or die "can't create file:$outFile";
print OUT ("#\n");





open(IF, "$infile") or die "****Error: Cannot open file: $infile\n";
  my @array=<IF>;
  close IF;

my $i = 0;
my $trypath="";
my @Sarray=();
for ($i=0;$i<@array;$i++){
	chomp($array[$i]);
  $array[$i]=~s/^\s*|\s*$//g;
	if ($array[$i] =~ /classpath/) {
		my @jars=split(/\;/,$array[$i]);
		for(my $j=0;$j<@jars;$j++){
			$trypath=$jars[$j];
			#open(LOG,">>$outFile");
			
			if ($jars[$j]=~/RAD_SHARED_HOME/){
				print LOGF "1$trypath";
				$trypath =~ s/\${RAD_SHARED_HOME}/$RADShareHome/g;
				print  LOGF "->$trypath\n";
				my @tmppath=split(/_/,$trypath);
				$trypath=$tmppath[0]."_";
				push(@Sarray,$trypath);
				print "**$trypath\n-";
	
			}else{
				open(OUT,">>$outFile");
				print OUT ("$trypath\;");
			}
		}

	}else{
		open(OUT,">>$outFile");
		print OUT ("$array[$i]\n");
        }
}


# get all files in provided dir
my @dirs = ($RADShareHome.'/');
print ("***$RADShareHome\n");
my ($dir, $file);
while ($dir = pop(@dirs)) {
	local *DH;
	if (!opendir(DH, $dir)) {
		warn "Cannot opendir $dir: $! $^E";
		next;
	}
	foreach (readdir(DH)) {
		if ($_ eq '.' || $_ eq '..') {
			next;
		}
		$file = $dir.$_;
		if (!-l $file && -d _) {
			$file .= '/';
			push(@dirs, $file);
		}
			
			for (my $x=0;$x<@Sarray;$x++){
							$trypath=$Sarray[$x];
					if($file=~/$trypath/){
						my $outpath=$file;
						$outpath=~s/$RADShareHome/\${RAD_SHARED_HOME}/g;
						open(OUT,">>$outFile");
						print OUT ("$outpath\;");
					}
				
				
			}
	}
	my $len=@dirs;
closedir(DH);
}

close LOGF;
close OUT;
