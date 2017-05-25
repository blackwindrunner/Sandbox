#!/usr/bin/perl -w

# Program: CheckCopyRight.perl
#
# This program will check the copyright information of our source code
# usage: perl CheckCopyRight.perl, it will check D:\Composer612

#
# Change history:
#   2009/04/07 LiuJuan added, to check general copyright, add or not
#   2010/01/28 LiuJuan updated, check file created and modified data:
#   1, for the new created file >2010/08/25, the copyright year is should be one:2011
#   2, for the new created file <2010/08/25, and updated file >2010/08/25, the copy right information should be ****, 2011 
#   for code checkin
#File -lock BTTTransactionBuilder/com.ibm.btt.tools.transaction/src/com/ibm/btt/tools/transaction/TypeCategory.java  -family  btt@bttcmvc.cn.ibm.com@8765 -defect 23735 -become cdlbuild -release composer700 
  


use strict;
use warnings;

my $prg_name="CheckCopyRight_update.perl";
my $Release=$ARGV[0];
die "Usage:\nperl $prg_name <release, such as:composer700>\n" if (@ARGV <1);

my $checkDir="D\:\/$Release";
my $tempfile1="D\:\/$Release\/Sandbox\/AllBuildLogs\/NewFile\_$Release.log";
my $tempfile2="D\:\/$Release\/Sandbox\/AllBuildLogs\/UpdateFile\_$Release.log";
my $outfile="D\:\/$Release\/Sandbox\/AllBuildLogs\/CheckCopyright\_new\_$Release.log";

my $family="btt\@9\.123\.123\.194\@8765";
system("c:\\cmvcreset.bat");

my $time_judge="2010/08/25";

my %comp;
my %newfile;
my %updatefile;



my @change1=();
my @change2=();
my $cmd1="Report -view FileView -raw -family $Family -where \"releaseName=\'$Release\' and addDate>\'$time_judge\'\"";
system($cmd1);
open(REPORT1, "$cmd1 |") or warn and exit -1;
print("**********$cmd1***********\n");
@change1=<REPORT1>;
close(REPORT1);

my $myi=@change1;

for (my $i1=0;$i1<$myi;$i1++){
	my @temp1=split (/\|/,$change1[$i1]);
	my $path1=$temp1[7];
	my $lpath1=$checkDir."\/".$path1;
	 $comp{$lpath1}=$temp1[2];
	 $newfile{$lpath1}=1;	
	}

my $cmd2="Report -view FileView -raw -family $Family -where \"releaseName=\'$Release\' and lastUpdate>\'$time_judge\'\"";
system($cmd2);
open(REPORT2, "$cmd2 |") or warn and exit -1;
print("**********$cmd2***********\n");
@change2=<REPORT2>;
close(REPORT2);

$myi=@change2;
#print("*********update change2 length:$myi *********@@@@@@@@@@\n");
for (my $i2=0;$i2<$myi;$i2++){
	my @temp2=split (/\|/,$change2[$i2]);
	my $path2=$temp2[7];
	my $lpath2=$checkDir."\/".$path2;
	 $comp{$lpath2}=$temp2[2];
	 $updatefile{$lpath2}=1;	
#	print("*********update file '$change2[$i2]' path:$lpath2*********@@@@@@@@@@\n");
	}


sub Check($) {

open(OUT,">$outfile");
print OUT   ("Please note, it only scan first 100 lines of the code.\nFollowing files don't contain any copyright variable statement information:\nprivate static final java.lang.String COPYRIGHT =\n");

my $cwd = shift;
my @dirs = ($cwd.'/');
print ("cmd: $cwd\n");

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
#print ("1file: $file");
if (!-l $file && -d _) {
$file .= '/';
#print ("2file: $file");
push(@dirs, $file);
}
if((($file=~/\.java$/) ||($file=~/\.js$/)) &&($file !~/dojo/)&&($file !~/SandBox/)&&($file !~/DSE/)&&($file !~/BTTAutomation/)&&($file !~/BTTBuild/)&&($file !~/BTTInstall/) &&($file !~/BTTTestUtil/) &&($file !~/BTTGUIAutomation/)&&($file !~/Composer/)&&($file !~/BTTGraphicalBuilder/)&&($file !~/Sample/) ){
process($file);
}
if($file =~/OperationExternalizer\.java/){

#process($file);
}

#print("************file: $file, dir:$dir\n");
}


closedir(DH);
}
}

my ($size, $dircnt, $filecnt) = (0, 0, 0);

sub process($) {
my $file1 = shift;
#print $file1, "\n";

my @line=();
open(FI, $file1) or next;
@line=<FI>; 
close FI;  
my $j=20;
if (@line <$j){$j=@line;}
my $word="\n";
my $i=0;
for ($i=0;$i<$j;$i++){
#chomp($line[$i]);

 $word.=$line[$i];
 #print("file: $file1, i:$i, line: $line[$i]\n");
# $word.="\n";
}
if((($word!~/5724-H82/) ||($word!~/IBM/) ) &&($word !~/The Apache Software License/)){

if(($word !~/5724-H82/) && ($word !~/IBM/)){

checkvariable($file1);

}elsif($word !~/5724-H82/){
open(OUT,">>$outfile");
print OUT ("$file1 --ERR00: no BTT copyright: 5724-H82\n");
}elsif($word !~/IBM/){
open(OUT,">>$outfile");
print OUT ("$file1 --ERR01:no IBM copyright\n");

}


}elsif(exists $newfile{$file1}){
	$word=~s/ //sgi;
	if (($word!~/2011/) ||($word=~/2011\,2011/)||($word=~/2010\,2011/)){
		
		#following codes are for batch lock the files that not comply with rules, for the purpose of developer's checkin convinience.
		# begin
		
		#my $lock_path=$file1;
		#$lock_path=~s/D\:\/composer700\///;
		#print("************lockfile: $lock_path\n");
		#File -lock BTTTransactionBuilder/com/ibm/btt/tools/transaction/TypeCategory.java  -family  btt@bttcmvc.cn.ibm.com@8765 -defect 23735 -become cdlbuild -release composer700 
    #my $cmd_lock="File -lock  $lock_path -family $Family  -defect 23735 -become cdlbuild -release $Release";
    #system($cmd_lock);
		
		#end
		
		open (OUT, ">>$outfile");
		print OUT ("$file1 --ERR03:new file need to mark one 2011,even it's added in 2010,cause 800 GA in 2011. such as:Copyright IBM Corp. 2011.\n");
	}
	
}elsif(exists $updatefile{$file1}){
	$word=~s/ //sgi;
	if ($word!~/2011/){
		
		#following codes are for batch lock the files that not comply with rules, for the purpose of developer's checkin convinience.
		# begin
		
		#my $lock_path=$file1;
		#$lock_path=~s/D\:\/composer700\///;
		#print("************lockfile: $lock_path\n");
		#File -lock BTTTransactionBuilder/com/ibm/btt/tools/transaction/TypeCategory.java  -family  btt@bttcmvc.cn.ibm.com@8765 -defect 23735 -become cdlbuild -release composer700 
    #my $cmd_lock="File -lock  $lock_path -family $Family  -defect 23735 -become cdlbuild -release $Release";
    #system($cmd_lock);
		
		#end
		
		open (OUT, ">>$outfile");
		print OUT ("$file1 --ERR04:update file need to mark 2011 as latter yesr, such as:Copyright IBM Corp. 2008,2011.\n");
	}
}

}

sub checkvariable($){
my $file2 = shift;

my @line=();
open(F2, $file2) or next;
@line=<F2>; 
close F2; 
my $j=200;
if (@line <$j){$j=@line;}
my $word="\n";
my $i=0;
for ($i=0;$i<$j;$i++){
#chomp($line[$i]);

 $word.=$line[$i];
 #print("file: $file1, i:$i, line: $line[$i]\n");
# $word.="\n";
}

if($word !~/static final java.lang.String COPYRIGHT/){
open(OUTV,">>$outfile");

print OUTV ("$file2 --ERR02:no copyright variable:static final java.lang.String COPYRIGHT\n")
}

}


Check($checkDir);



