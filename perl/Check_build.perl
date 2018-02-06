#!/usr/local/bin/perl -w

# Program: Check_build.perl
# This program used to check the build result
# Change history:
#   2008/7/17 lwh created it used by build_bvt.bat.


#require 'ctime.pl';
select(STDOUT); $| = 1; # flush after every write
use strict;
#use SendMail;
use Cwd;
## 判断环境变量中是否存在版本，如果不存在，通过setupenv为perl设定环境变量
if(!$ENV{VERSION}){
	my @lines=`call ..\\setupenv.bat && set`;
	foreach (@lines) {
		next unless /^(\w+)=(.*)$/;
		$ENV{$1}=$2;
	}
}

#use dependencies;

my $release="composer$ENV{VERSION}";
#print "VERSION=$ENV{VERSION}\n";
my $buildDir=$ENV{ENG_WORK_SPACE};
#print "ENG_WORK_SPACE=$ENV{ENG_WORK_SPACE}\n";
if(index($buildDir,"\\")!=-1){
	my $replace_to="\\";
	my $replace_with="";
	substr($buildDir,index($buildDir,$replace_to),length($replace_to),$replace_with);
	#print "$buildDir\n";
}elsif(index($buildDir,"/")!=-1){
	my $to="/";
	my $with="\\";
	substr($buildDir,index($buildDir,$to),length($to),$with);
	#print "$buildDir\n";
}


my $cmd;
my $family="btt\@9\.123\.123\.194\@8765";



	open(HTML, ">$buildDir\\SandBox\\AllBuildLogs\\build_check\.html") or die "Cannot open $buildDir\\SandBox\\AllBuildLogs\\build_check\.log: $!\n";
  
  (my $sec,my $min,my $hour,my $mday,my $mon,my $year,my $wday,my $yday,my $isdst) = localtime(time);
    if ($hour < 10 ) { $hour = "0$hour" }
    if ($min < 10 ) { $min = "0$min" }
    if ($sec < 10 ) { $sec = "0$sec" }
    $year -= 100; # need to make at least two digits
  	$year = sprintf "%2.2d", $year . "\n"; # and make sure it shows up as two characters
 		 ++$mon;
  	$mon = sprintf "%2.2d", $mon . "\n";
  	$mday = sprintf "%2.2d", $mday . "\n";
  	my $daytime="$mon/$mday/20$year";
    my $hms="$hour:$min:$sec";
    
    
    print HTML "<html>\n";
    print HTML "<head>\n";
    print HTML "<meta http-equiv=Content-Type content=\"text/html; charset=US-ASCII\">\n";
    print HTML "<title>BTT Build Report\n";
    #print HTML "<link title=\"Style\" type=\"text/css\" rel=\"stylesheet\" href=\"stylesheet.css\">\n";
    print HTML "</title>\n";
    print HTML "</head>\n";
    print HTML "<body>\n";
    print HTML "<center><b><font color=blue size=+2>$ENV{VERSION} Build Report </font><font color=blue size=+1> ( $daytime  $hms )</font>\n";
    print HTML "<center><b><font color=blue size=+2></font>\n";
    print HTML "<center><table width=\"95%\" cellspacing=\"2\" cellpadding=\"5\" border=\"1\" class=\"details\">\n";
	
	if (-e "$buildDir\\SandBox\\$ENV{VERSION}.txt"){
      
			open(COMFILE, "$buildDir\\SandBox\\$ENV{VERSION}.txt");
			my @comline = <COMFILE>;
			close COMFILE;
			

			for (my $com =0; $com < $#comline+1; $com++){
                   	  chomp($comline[$com]);
					if (-e "$buildDir\\$comline[$com]\\logs\\ant\.log"){
                                         
							open(ANTFILE, "$buildDir\\$comline[$com]\\logs\\ant\.log");
							my @antlines = <ANTFILE>;
							close ANTFILE;
							
							for (my $num = 0; $num < ($#antlines+1); $ num++){
							            
									if ($antlines[$num] =~ m/BUILD FAILED/) {
                                                     
									  print HTML "<tr> <td><font color=red>$comline[$com]: </font></td> <td><font color=red> BUILD FAILED: $antlines[($num+1)]</td></tr></font>";
									  #open build failed defect
                                                        
                                                        #$cmd = "Defect -open -family $family -release $release -component $comline[$com] -severity 1 -remarks \"$antlines[($num+1)]\" -abstract \"BVT: Build Failed\" -prefix d -phaseFound building -symptom build_failed -activity ft -odctrigger coverage -impact installability"; 
                                                        #print "\n$cmd\n";
                                                        #system($cmd);
			                                      #print HTML "\n\t**** $comline[$com]:  BUILD FAILED ****\n\tBUILD FAILED:  $antlines[($num+1)]\n";
									} 
									elsif ($antlines[$num] =~ m/BUILD SUCCESSFUL/) {
									  print HTML "<tr> <td><font color=blue>$comline[$com]:</font> </td> <td> <font color=blue>BUILD SUCCESSFUL</font></td></tr>";
										#print HTML "\n\t**** $comline[$com]:  BUILD SUCCESSFUL ****\n\n";
									}
 							} 							
			     }			
			}
}
    print HTML "</table>\n";
    print HTML "</body>\n";
    print HTML "</html>\n";

close HTML;
 
if (-e "$buildDir\\SandBox\\AllBuildLogs\\build\.fail"){
		system ("del $buildDir\\SandBox\\AllBuildLogs\\build\.fail");
}
 
if (-e "$buildDir\\SandBox\\AllBuildLogs\\build_check\.html"){ 
      open(BUILDFILE, "$buildDir\\SandBox\\AllBuildLogs\\build_check\.html");
			my @buildline = <BUILDFILE>;
			close BUILDFILE;
			
			
			foreach my $buildst (@buildline){
			    if ($buildst =~ m/BUILD FAILED/){			    
			       system ("cd>$buildDir\\SandBox\\AllBuildLogs\\build\.fail");
			       exit 1;
			    }
			}
}
