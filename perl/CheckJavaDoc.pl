#!/usr/bin/perl -w

# Program: CheckJavaDoc.perl
#
# This program will check the copyright information of our source code
# usage: perl CheckJavaDoc.perl, it will check D:\Composer612

#
# Change history:
#   2009/05/31 LiuJuan added, to check javadoc
#   2009/09/07 updated, advanced check java doc rules:
#   1, for the new added or updated files,
#                                                                                new added:2009/09/01-2009/12/31: 2009, 2010/**/** :2010
#                   updated:2009/09/07-2009/12/31: 2009, >2010: 2010
#   2, parameter(a,b,c,...), @param
#   3, return object
#   4, if throw exception
#   5, DSE.ini, dse*.xml check in comments

#/**
#         * Returns the RequestValidationServices instance associated with the
#         * current session.
#         *
#         * @return RequestValidationServices RequestValidationServices object
#         *         associated with given session
#         * @param cc
#         *            com.ibm.btt.clientserver.ChannelContext ChannelContext used to
#         *            get the session
#         * @throws DSEException
#         *             Either it is not possible to retrieve a sessionId from the
#         *             channelContext or there is no session associated with the
#         *             sessionId.
#         */
#        public RequestValidationServices getRVS(ChannelContext cc) throws DSEException {
#                String sessionId = getSessionId(cc);
#

use strict;
use warnings;

my $prg_name="CheckJavaDoc.perl";
my $Release=$ARGV[0];
die "Usage:\nperl $prg_name <release, such as:composer8210>\n" if (@ARGV <1);

my $checkDir=$main::buildDir;
my $outfile="$checkDir\/Sandbox\/AllBuildLogs\/CheckJavadoc\_$Release.log";

sub Check($) {

open(OUT,">$outfile");
print OUT ("Following public methods in java class has no Java doc statement:\n\n\n");

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
if((($file=~/\.java$/) ||($file=~/\.js$/)) &&($file !~/XUITable/) &&($file !~/NotSupportedAttributeTypeException/) &&($file !~/ConfigSimpleElementManagerException/)&&($file !~/ElementException/)&&($file !~/UniversalElementFactory/)&&($file !~/com\/ibm\/btt\/element\/simple\/impl/) &&($file !~/com\/ibm\/btt\/element\/impl/) &&($file !~/com\/ibm\/btt\/element\/exception/) &&($file !~/BTTRichClientMonitor/) &&($file !~/BTTBusinessComponent/) &&($file !~/JMSUtil/)&&($file !~/MobileRequest/) &&($file !~/EJBInvoker/) &&($file !~/JMSInvoker/) &&($file !~/pojo/)&&($file !~/InvokerTimerTask/) &&($file !~/InvokerDaemon/) &&($file !~/StringUtils/) &&($file !~/InvokerUtils/) &&($file !~/GenericEmitter/) &&($file !~/GenericDataObjectTarget/) &&($file !~/GenericDataObjectSerializer/)&&($file !~/GenericDataObjectDeSerializer/) &&($file !~/DIIUtils/) &&($file !~/WSDIIvoker_WSDLExtractor/) &&($file !~/WebServiceManager/) &&($file !~/RegexTagProvider/) &&($file !~/InvokerProcessor/) &&($file !~/SortedTable/) &&($file !~/StringVectorSerializer/) &&($file !~/StringHashtableSerializer/) &&($file !~/JavaExtensions/) &&($file !~/StringArraySerializer/) &&($file !~/HtmlTransitionDescriptor/)&&($file !~/SSLEnabler/)&&($file !~/HtmlRequestData/)&&($file !~/dojo/)&&($file !~/struts/)&&($file !~/portal/)&&($file !~/SandBox/)&&($file !~/DSE/)&&($file !~/BTTAutomation/) && ($file !~/BTTToolsAPAR/)&&($file !~/BTTBuild/)&&($file !~/BTTInstall/) &&($file !~/BTTTestUtil/) &&($file !~/BTTGUIAutomation/)&&($file !~/Composer/)&&($file !~/BTTGraphicalBuilder/)&&($file !~/Sample/)&&($file !~/BTTValidationTool/)&&($file !~/BTTTransactionBuilder/)&&($file !~/BTTTransactionBasedTool/) &&($file !~/BTTToolsXUIEditor/)&&($file !~/BTTToolsMigration/)&&($file !~/BTTToolsFormatterSimulator/)&&($file !~/BTTToolsDDEEditor/)&&($file !~/BTTToolsAppWizard/)&&($file !~/BTTCHAEJB/)&&($file !~/BTTBusinessLogic/)&&($file !~/BTTLu0Connector/)&&($file !~/BTTLu62Connector/)&&($file !~/BTTDummySnaLu0Connector/) ){
process($file);
}


#print("************file: $file, dir:$dir\n");
}


closedir(DH);
}
}

sub process($) {
my $file1 = shift;
#print $file1, "\n";

my @line=();
open(FI, $file1) or next;
@line=<FI>;
close FI;
my $j=@line;
my $interfaceflag=0;
my $temp="";
#my $temp1="";
#my $temp2="";
my $counter=0;
my $comment="";
my $flag=0;  # flag to comment begin(1) or end(0)
if($j>=5){
        for (my $i=5;$i<$j;$i++){
        $line[$i]=~s/^\s+//g;	
        chomp($line[$i]);
        $line[$i]=~s/^\s*|\s*$//g;

        if ($line[$i]=~/^\/\*\*/) {

             $comment.=$line[$i];
             $flag =1;  #comments begin
        } elsif ($line[$i]=~/^\*/){
        	$flag =1;
             $comment.=$line[$i];
        } elsif($line[$i]=~/^\@/){
        	$flag =1;
        	   $comment.=$line[$i];
        } elsif($line[$i]=~/^\/\//){
        	$flag =1;
        	   $comment.=$line[$i];
        }else{
             if(($line[$i]=~/^public/) &&($line[$i]!~/^public static final/)&& ($line[$i]!~/^public final static/)&& ($line[$i]!~/\=/)){
             	if($line[$i]=~/interface/){$interfaceflag=1;}
             	
             	  $temp=$line[$i-5]. $line[$i-4].$line[$i-3].$line[$i-2].$line[$i-1];
          			chomp($temp);
          			if ($temp!~/\*\//){
              		my $lastchar= chop($temp);
              		
		                   if((($lastchar!~/\;/) &&($lastchar!~/\}/)) && ($line[$i]!~/^[a-zA-Z]*\s+[a-zA-Z]*\(\)\s+\{$/)) {
		                  	#if($lastchar!~/\{/){
		                          open(OUT,">>$outfile");
		                           print OUT ("$file1 -> $line[$i]  -> error JDE000: lack of comments\n");
		                           $flag=0;
		                  }
                  


          			}
          			if($flag eq 1){
                  if((index($line[$i],"\(")>0)&&(index($line[$i],"\)")>0)&&(index($line[$i],"interface")<0)){
                      #public RequestValidationServices getRVS(ChannelContext cc, aa c) throws DSEException,IOException {

                       my @temparray=split(/\(/,$line[$i]);
                       chomp($temparray[0]);
                       my @temp1=split(/\s+/,$temparray[0]);  # public RequestValidationServices getRVS

											 # get return method name	if it's not interface
											 if($interfaceflag eq 0){
											 	
													 my $temp1Len=@temp1;
													 if($temp1Len>2){    # if it's a class will return result.
													 	 my $returnclass=$temp1[$temp1Len-2];             # get method name: RequestValidationServices
		                       	 if ($returnclass ne "void"){
		                            if((index($comment,$returnclass)<0) ||(index($comment,"return")<0)){
		                            	
		                            	if(index($file1,"D:/composer700/BTTWeb2Container/src/com/ibm/btt/web2/transformation/XmlJsonTransformer.java")>=0){
		                            		open(OUT,">>$outfile");
		                            		print OUT ("****$comment**$returnclass****\n");
		                            		}
		                            	
		                               open(OUT,">>$outfile");
		                               print OUT ("$file1 -> $line[$i] -> error JDE001: lack of return class in comments: return $returnclass\n");
		                            }
		                         }
													 }
											 }	
                      
                       # get input paramters
                      
                       chomp($temparray[1]);
                       my @templater=split(/\)/,$temparray[1]);
                       chomp($templater[0]); 
                        print "$file1 -> $line[$i] ->$templater[0] ";
                       if (length($templater[0])>1){    # get input parameter there's input parameters
                          if(index($templater[0],",")<0){  # one parameter
                          	  my @paramtemp= split(/\s+/,$templater[0]);
                              my $param_type=$paramtemp[0];
                              my $param_name=$paramtemp[1];
                              print " ->**$param_name\n";
                             #if((index($comment,my $param_type)<0) ||(index($comment,my $param_name)<0)){
                             if(index($comment, $param_name)<0){
                               open(OUT,">>$outfile");
                               print OUT ("$file1 -> $line[$i] -> error JDE002: lack of input parameter in comments:$param_type $param_name\n");
                            }
                             
                          }else{                                              #multiple parameters
                              my @paramarray=split(/\,/,$templater[0]);    # ChannelContext cc
                              for (my $ii=0;$ii<@paramarray;$ii++){
                              	 my @paramtemp=split(/\s+/,$paramarray[$ii]);
                              	 my $param_type=$paramtemp[0];
                             		 my $param_name=$paramtemp[1];
                             		 print " ->****$param_name\n";
                             		#if((index($comment,my $param_type)<0) ||(index($comment,my $param_name)<0)){
                             		if(index($comment, $param_name)<0){
                               		open(OUT,">>$outfile");
                               		print OUT ("$file1 -> $line[$i] -> error JDE002: lack of input parameter in comments:$param_type $param_name\n");
                           		 }
                              	
                              }
                          }

                       }
                       
                       # get throw exception
                       if (index($templater[1],"throws")>=0){ # get exception information "throws", length is 6  
                       		chomp($templater[1]);	
                          my @temp2=split(/\s+|\,/,$templater[1]);
                          my $exceptionString=$temp2[1];
                          if((index($comment, $exceptionString)<0) ||((index($comment,"throws")<0) &&(index($comment,"exception")<0))){
                               open(OUT,">>$outfile");
                               print OUT ("$file1 -> $line[$i] -> error JDE003: no throw exception information in comments:throws $exceptionString\n");
                            }
                       
                     	  
                       }
                       
                }
              }


            }elsif($line[$i]=~/^\*\*\//){
                
                #comments end
                
            }
             
             if (($comment=~/dse.ini/i) || ($comment=~/dse.ini/i) ||($comment=~/dsectxt.xml/i) ||($comment=~/dsedata.xml/i) ||($comment=~/dsetype.xml/i) ||($comment=~/dsefmts.xml/i) ||($comment=~/dseoper.xml/i) ||($comment=~/dseproc.xml/i) ||($comment=~/dsesrvce.xml/i) ){
             	open(OUT,">>$outfile");
              print OUT ("$file1 -> error JDE004: DSE related trace in comments\n");
                           
             	}

            $comment="";
        }






        }
}

}

Check($checkDir);
