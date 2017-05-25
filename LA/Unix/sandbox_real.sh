#!/usr/bin/bash

source /SandBox/setupenv.sh

rm -rf $release
jar -xf $BTT_HOME/$release.zip
rm -rf $BTT_HOME/$release.zip

> $BTT_HOME/sandbox.log

CP=/usr/bin/cp
$CP  $BTT_HOME/setupenv.sh $ENG_WORK_SPACE/SandBox/setupenv.sh
$CP  $BTT_HOME/build.properties $ENG_WORK_SPACE/BTTAutomation/build.properties
$CP -r $BTT_HOME/BTTAutomation $ENG_WORK_SPACE/
#$CP -r $BTT_HOME/BTTAutomation $ENG_WORK_SPACE/BTTAutomation

# copy c:/sandbox/build.xml $ENG_WORK_SPACE/BTTAutomation/build.xml /Y
# copy c:/sandbox/CHAEX04/case.xml $ENG_WORK_SPACE/BTTAutomation/fvt/CHAEX04/case.xml /Y
# copy c:/sandbox/WSDII/case.xml $ENG_WORK_SPACE/BTTAutomation/fvt/WSDII/case.xml /Y

# $ENG_WORK_SPACE/SandBox/build_level.sh
# echo level_serialbuild=%level_serialbuild:~-8,8%>>$ENG_WORK_SPACE/BTTAutomation/build.properties

WAS_ANT=$WAS_HOME/bin/ws_ant.sh
$WAS_ANT -f $ENG_WORK_SPACE/BTTAutomation/init.xml checkBackends

$WAS_ANT -k -f $ENG_WORK_SPACE/BTTAutomation/build.xml -Dcategory=unit -Drebuild=true runAllUnit
$WAS_ANT -k -f $ENG_WORK_SPACE/BTTAutomation/build.xml -Dcategory=unit -Drebuild=true sendReportToWebsite

$WAS_ANT -k -f $ENG_WORK_SPACE/BTTAutomation/build.xml -Dcategory=fvt -Drebuild=true runFvt
$WAS_ANT -k -f $ENG_WORK_SPACE/BTTAutomation/build.xml -Dcategory=fvt -Drebuild=true runAllFvtCaseWithOutWas
$WAS_ANT -k -f $ENG_WORK_SPACE/BTTAutomation/build.xml -Dcategory=fvt -Drebuild=true sendReportToWebsite

$WAS_ANT -k -f $ENG_WORK_SPACE/BTTAutomation/build.xml -Dcategory=svt -Drebuild=true runSvt
$WAS_ANT -k -f $ENG_WORK_SPACE/BTTAutomation/build.xml -Dcategory=svt -Drebuild=true sendReportToWebsite
