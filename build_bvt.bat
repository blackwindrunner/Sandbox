@echo off
echo build_bvt start
cd D:\\composer8210\\SandBox
call D:\\composer8210\\SandBox\\setupenv.bat
perl -S D:\\composer8210\\SandBox\\perl\\Check_need_build.perl >>D:\\composer8210\\SandBox\\AllBuildLogs\\Check_need_build.log
call D:\\composer8210\\SandBox\\need_build.bat
echo %Need_Build%
if "%Need_Build%"=="Yes" (
    call D:\\composer8210\\SandBox\\del.bat
    perl -S D:\\composer8210\\SandBox\\perl\\CreateLevel_S.perl -r composer8210 -t integration>>D:\\composer8210\\SandBox\\AllBuildLogs\\createLevel.log
	call D:\\composer8210\\SandBox\\build.bat -c excbuilddse
	call D:\\composer8210\\SandBox\\build.bat -c excbuildall
	rem BTTBusinessTemplate and BTTWeb2JSLib build btt.js 3 times
    rem call D:\\composer8210\\SandBox\\build.bat -c excbuildother
    rem call D:\\composer8210\\Sandbox\\build.bat -c excbuildGTB
    perl -S D:\\composer8210\\SandBox\\perl\\AddLevelToAutomation.perl>D:\\composer8210\\SandBox\\AllBuildLogs\\level_serialbuild.log
    call D:\\composer8210\\SandBox\\build.bat -c j9build
    call D:\\composer8210\\SandBox\\build.bat -c installbuild
    call D:\\composer8210\\SandBox\\updateSite.bat
    perl -S D:\\composer8210\\SandBox\\perl\\Check_build.perl >>D:\\composer8210\\SandBox\\AllBuildLogs\\check_build.log
    rem perl -S D:\\CodeScan\\CheckCopyRight.pl composer8210
    perl -S D:\\composer8210\\SandBox\\perl\\CheckJavaDoc.pl composer8210
    perl -S D:\\composer8210\\SandBox\\perl\\CheckCopyRight_update.pl composer8210 >test.log
    perl -S D:\\CodeScan\\DefectAnalysis\\CheckCommonFile.pl composer801 composer8210
    if not exist D:\\composer8210\\SandBox\\AllBuildLogs\\build.fail (
        rem  Build Successfully send mail build_check.html(build_put.xml)
        ant -buildfile D:\\composer8210\\SandBox\\build_bvt.xml -logfile D:\\composer8210\\SandBox\\AllBuildLogs\\build_bvt.log -verbose
        echo build successful!!!
        call D:\\composer8210\\SandBox\\build_complete.bat
        call D:\\composer8210\\SandBox\\build_put.bat
		ant -buildfile D:\\composer8210\\SandBox\\build_IA.xml -logfile D:\\composer8210\\SandBox\\AllBuildLogs\\build_IA.log -verbose
        ant -buildfile D:\\composer8210\\SandBox\\sendmail_build_successful.xml -logfile D:\\composer8210\\SandBox\\AllBuildLogs\sendmail.log -verbose
        echo complete level successful!!!
        
    ) else (
        rem  Build Failed send fail mail
        ant -buildfile D:\\composer8210\\SandBox\\build_fail.xml
        perl -S D:\\composer8210\\SandBox\\perl\\DeleteLevel.perl -r composer8210 >>D:\\composer8210\\SandBox\\AllBuildLogs\\DeleteLevel.log
        call D:\\composer8210\\SandBox\\build_level.bat
        echo level=%level_serialbuild%>>C:\\LocalSettings.properties
        ant -buildfile D:\\composer8210\\SandBox\\sendmail_build_failed.xml -logfile D:\\composer8210\\SandBox\\AllBuildLogs\sendmail.log -verbose
        echo build failed!!!
    )
    
) else (
    rem needn't build send mail
    ant -buildfile D:\\composer8210\\SandBox\\sendmail_no_build.xml -logfile D:\\composer8210\\SandBox\\AllBuildLogs\sendmail.log -verbose
    echo No build!!!
) 