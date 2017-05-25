@echo off

cd D:\\composer710\\SandBox
call D:\\composer710\\SandBox\\setupenv.bat
perl -S D:\\composer710\\SandBox\\perl\\Check_need_build.perl >>D:\\composer710\\SandBox\\AllBuildLogs\\Check_need_build.log
call D:\\composer710\\SandBox\\need_build.bat
echo %Need_Build%

if "%Need_Build%"=="Yes" (    
    call D:\\composer710\\SandBox\\del.bat
    perl -S D:\\composer710\\SandBox\\perl\\CreateLevel_S.perl -r composer710 -t integration >>D:\\composer710\\SandBox\\AllBuildLogs\\createLevel.log
    call D:\\composer710\\SandBox\\build.bat -c excbuildall    
    perl -S D:\\composer710\\SandBox\\perl\\AddLevelToAutomation.perl > D:\\composer710\\SandBox\\AllBuildLogs\\level_serialbuild.log
    call D:\\composer710\\SandBox\\build.bat -c j9build
    call D:\\composer710\\SandBox\\build.bat -c installbuild
    
    rem call D:\\CodeScan\\Scan.bat
    rem cd D:\\composer710\\SandBox
    rem when check, open defect
    perl -S D:\\composer710\\SandBox\\perl\\Check_build.perl >>D:\\composer710\\SandBox\\AllBuildLogs\\check_build.log
    if exist D:\composer710\\\BTTInstallPackaging\\build.xml{ 
    	if not exist D:\\composer710\\SandBox\\AllBuildLogs\\build.fail (
        rem  Build Successfully send mail build_check.html(build_put.xml)
        ant -buildfile D:\\composer710\\SandBox\\build_bvt.xml -logfile D:\\composer710\\SandBox\\AllBuildLogs\\build_bvt.log -verbose
        echo build successful!!!

        call D:\\composer710\\SandBox\\build_complete.bat
        call D:\\composer710\\SandBox\\build_put.bat
                 
         
        rem call D:\\composer710\\SandBox\\setupenv.bat
				rem call D:\\composer710\\SandBox\\build_level.bat 
				rem echo level=%level_serialbuild%>>C:\\LocalSettings.properties
        ant -buildfile D:\\composer710\\SandBox\\sendmail_build_successful.xml -logfile D:\\composer710\\SandBox\\AllBuildLogs\sendmail.log -verbose
        echo complete level successful!!!
        
    	) else (
        rem  Build Failed send fail mail
        ant -buildfile D:\\composer710\\SandBox\\build_fail.xml
        call D:\\composer710\\SandBox\\build_level.bat
        echo level=%level_serialbuild%>>C:\\LocalSettings.properties
        ant -buildfile D:\\composer710\\SandBox\\sendmail_build_failed.xml -logfile D:\\composer710\\SandBox\\AllBuildLogs\sendmail.log -verbose
        echo build failed!!!
    	)
    } else{
       ant -buildfile D:\\composer710\\SandBox\\sendmail_extract_failed.xml -logfile D:\\composer710\\SandBox\\AllBuildLogs\sendmail.log -verbose
       echo extract build failed!!!
    }

    rem copy source files to was7 build home then invoke was7 build
    rem ant -buildfile D:\\composer710\\SandBox\\copy_src.xml -logfile D:\\composer710\\SandBox\\AllBuildLogs\\copy_src.log -verbose
    rem call D:\\composer710_was7\\SandBox\\build_bvt.bat    

) else (
    rem needn't build send mail
    ant -buildfile D:\\composer710\\SandBox\\sendmail_no_build.xml -logfile D:\\composer710\\SandBox\\AllBuildLogs\sendmail.log -verbose 
    echo No build!!!
) 

