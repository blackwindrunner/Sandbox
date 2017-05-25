#!/usr/bin/perl

#-------------------------------------------------------------------------------------------------------
# Program: DefectRegressionAdviser.perl
# This program will analysis the defect code change in CMVC, map the function domain with change history, provide 
# regression adviser to tester.
# -------------------------
# Inputs:
# -------
#   1. release - the release that is being analysised.
#   2. level - the level to do the final extract on
#   3. excel file - the excel file to contain the mapping function domain information
#   4. Output file - the outpur adviser file 

# Change history:
# ---------------
# 04/18/2011 - Liu Juan, created
# 10/19/2011 - Liu Juan, updated, read multiple tab of one excel file. 


use File::Copy;
use Sort::Fields;
use HTTP::Date;
use strict;
use Win32::OLE;
use Win32::OLE::Const 'Microsoft Excel';
$Win32::OLE::Warn = 3; 


select(STDOUT); $| = 1; # flush after every write

print "\t=\>$0\n";
my $usage = $0;
$usage =~ s%.*/(\S+)%$1%;
$usage .= " -r Release -l CMVC_Level -f Excel mapping file \n";
my $family="btt\@9\.123\.123\.194\@8765";


my $Release;
my $LevelName;
my $ExcelFile;
my $OutFile;

@ARGV = ('-') unless @ARGV;
while ($ARGV = shift ) {
  if ($ARGV =~ m/-r/i) {
    $Release = shift or usage();
  } elsif ($ARGV =~ m/-l/i) {
    $LevelName = shift or usage();
  } elsif ($ARGV =~ m/-f/i) {
    $ExcelFile = shift or usage();  
  }  
}

sub getWeight;
#read the Excel file
my $excel = Win32::OLE->GetActiveObject('Excel.Application') ||Win32::OLE->new('Excel.Application', 'Quit');
my $open_excel_file = $excel->Workbooks->Open($ExcelFile) || die Win32::OLE->LastError(); 
my $current_sheet = $open_excel_file->Worksheets(1);
my $row_count = $current_sheet->UsedRange->Rows->Count;
my $column_count =$current_sheet->UsedRange->Columns->Count;
# print "row: $row_count\n column:$column_count\n";
my @BTTpackage;
my @BTTfunction;
my $tempCell;
my %pindex;  #package index
my %findex;   #function index
my %weight;   # function weight
my %defectReg;  #defect refresson suggest

# get package list
for (my $i=2;$i<=$column_count;$i++){
	$tempCell=$current_sheet->Cells(1,$i)->{"Value"};
	if (length($tempCell)<=0){$tempCell=0;}
	$BTTpackage[$i-2]=$tempCell;
	$pindex{$BTTpackage[$i-2]}=$i;
	}

# get function list	
for (my $i=2;$i<=$row_count;$i++){
	$tempCell=$current_sheet->Cells($i,1)->{"Value"};
	if (length($tempCell)<=0){$tempCell=0;}
	$BTTfunction[$i-2]=$tempCell;
	$findex{$BTTfunction[$i-2]}=$i;
	#initialize function weight
	$weight{$BTTfunction[$i-2]}=0;
	}

#component name:
my $compName=$current_sheet->Cells(1,1)->{"Value"};
my %reg;
$reg{$compName}=1;



# print "@BTTpackage\n";
# print "@BTTfunction\n";

 


#login BTT CMVC to get the change history of the indicated level
system("c:\\cmvcreset.bat");
my $cmd = "Level -map $LevelName -family $family -release $Release"; # List all the parts in the level
#$cmd="Report -view ChangeView -where 'levelID in \(select id from levelView where name\=\"\$LevelName\" and releaseName\=\"\$Release\"\) order by pathName'-raw "; 
my $cmd2 ="Report -g ChangeView -family $family -where \"releaseName in '$Release' and levelName in '$LevelName'\" -select \"pathName, Defectname,defectType\"";

my $defectString="";
  open(QUERY, "$cmd |");
  my @lines = <QUERY>;
  close(QUERY);
  
  open(QUERY, "$cmd2 |");
  my @lines2 = <QUERY>;
  close(QUERY);
  
  
 

my %packageString; #package string of each defect;
foreach my $line(@lines2){
	# print "$line";
	my @temp= split(/\|/,$line);
	my $ipath=$temp[0];
	my $defect=$temp[1];
	if (index($defectString,$defect)<0){$defectString.="\|$defect";}
	my $icomponent= substr($ipath,0,index($ipath,"\/"));
	my $pi=index($ipath,"com\/");
	my $tempString=substr($ipath, $pi);
	my $pj=rindex($tempString,"\/");
	$tempString=substr($tempString,0,$pj);
	$tempString=~s/\//\./g;
# 	print "()***$icomponent\t $tempString\t $defect\n";
	$packageString{$defect}.="\|$tempString";
	}
	
my @defectArray=split(/\|/,$defectString);
my %defectAdviser;
foreach my $i(@defectArray){
	 # print"()()()()$i\t $packageString{$i}\n";
	if((length($i)>0) && {index($packageString{$i},"com")>=0}){
		$defectAdviser{$i}=getWeight($packageString{$i});
		#print "()()()()()$i)\t$defectAdviser{$i}\n";
		
	}else{
		$defectAdviser{$i}="";
		}
	
	}

foreach my $line (@lines){
	#print "$line";
	my @temp= split(/\|/,$line);
	my $icomponent=$temp[3];
	my $ipath=$temp[5];
	my $iaction=$temp[7];
	my $pi=index($ipath,"com\/");
	my $tempString=substr($ipath, $pi);
	my $pj=rindex($tempString,"\/");
	$tempString=substr($tempString,0,$pj);
	$tempString=~s/\//\./g;
	
	# print "\n1$icomponent\t 2$ipath\t 3$iaction\t 4 $tempString\n";
	if($icomponent eq $compName){
		for(my $i=2;$i<=$row_count;$i++){
			$tempCell=$current_sheet->Cells($i,$pindex{$tempString})->{"Value"};
	    if (length($tempCell)<=0){$tempCell=0;}
			$weight{$BTTfunction[$i-2]}+=$tempCell;
			#print "\n**$BTTfunction[$i-2]\t$weight{$BTTfunction[$i-2]}\n";
			}
		}	
	}
	
#for(my $i=0;$i<=$row_count-2;$i++){
#	if($weight{$BTTfunction[$i]}>0){
#		
#		print "\n ****\n$BTTfunction[$i]\t $weight{$BTTfunction[$i]}";
#		}
#	
#	}	
	
	
		
		
		my $cmd ="Report -g ChangeView -family $family -where \"releaseName in '$Release' and levelName in '$LevelName'\" -select \"pathName, Defectname,defectType\"";
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
       printf("%-50s%-20s%-20s%-100s\n", $component, $defectType, $defectName, $defectAdviser{$defectName});
       $oldComponent = $component;
       $oldDefectName = $defectName;
    }

 }
     print("\n\nTotally Test Advice:\n ");
    # sort with the weight of each function and print:
		foreach my $key (sort {$weight{$b} <=> $weight{$a}} keys %weight){
			if($weight{$key}>0){
				print "$key=> $weight{$key}\n";
				}
			
		}

# get weight of a package array	
sub getWeight{
	my %weightdefect;
	my($tempName)=@_;
	my @packageName=split(/\|/,$tempName);
	my $outString="";
	
	for (my $i=2;$i<=$row_count;$i++){
		$weightdefect{$BTTfunction[$i-2]}=0;
	}
	my $packagelength=@packageName;
	
	for(my $i=1; $i<$packagelength; $i++){
		my $tempString=$packageName[$i];
		# print "sub****** :$tempString\n";
		if($pindex{$tempString}>0){
		for(my $j=2;$j<=$row_count;$j++){
			$tempCell=$current_sheet->Cells($j,$pindex{$tempString})->{"Value"};
	    if (length($tempCell)<=0){$tempCell=0;}
			$weightdefect{$BTTfunction[$j-2]}+=$tempCell;
				# print "*******1$BTTfunction[$j-2] 2 $tempCell\n";
			}
			
		}
	  }
		foreach my $key (sort {$weightdefect{$b} <=> $weightdefect{$a}} keys %weightdefect){
			if($weightdefect{$key}>0){
				$outString.="\|$key->$weightdefect{$key}";
				}
				
			
		}
		#print "subsub :1 $tempName 2 $outString\n";
	
	return $outString;
		
	
	}	

