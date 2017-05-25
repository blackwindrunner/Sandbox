@echo off

cd D:\\composer8210\\SandBox
call D:\\composer8210\\SandBox\\setupenv.bat
perl -S D:\\composer8210\\SandBox\\perl\\Check_need_build.perl >>D:\\composer8210\\SandBox\\AllBuildLogs\\Check_need_build.log
call D:\\composer8210\\SandBox\\need_build.bat
echo %Need_Build%
if "%Need_Build%"=="Yes" (
    call D:\\composer8210\\SandBox\\del_refactor.bat
    perl -S D:\\composer8210\\SandBox\\perl\\CreateLevel_S.perl -r composer8210 -t integration>>D:\\composer8210\\SandBox\\AllBuildLogs\\createLevel.log
    call D:\\composer8210\\SandBox\\build.bat -c refactor
    perl -S D:\\composer8210\\SandBox\\perl\\Check_build.perl >>D:\\composer8210\\SandBox\\AllBuildLogs\\check_build.log
    if not exist D:\\composer8210\\SandBox\\AllBuildLogs\\build.fail (
        rem  Build Successfully send mail build_check.html(build_put.xml)
        echo build successful!!!
        perl -S D:\\composer8210\\SandBox\\perl\\DeleteLevel.perl -r composer8210        
        echo complete level successful!!!        
    	) else (
        rem  Build Failed send fail mail
        perl -S D:\\composer8210\\SandBox\\perl\\DeleteLevel.perl -r composer8210
        call D:\\composer8210\\SandBox\\build_level.bat
        echo level=%level_serialbuild%>>C:\\LocalSettings.properties
        echo build failed!!!
    	)    
) else (
    echo No build!!!
) 

