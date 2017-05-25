call D:\\composer8210\\SandBox\\build.bat -c installbuild


call D:\\CodeScan\\Scan.bat
cd D:\\composer8210\\SandBox
rem when check, open defect
perl -S D:\\composer8210\\SandBox\\perl\\Check_build.perl >>D:\\composer8210\\SandBox\\AllBuildLogs\\check_build.log
if exist D:\composer8210\\\BTTInstallPackaging\\build.xml(
	if not exist D:\\composer8210\\SandBox\\AllBuildLogs\\build.fail (
    rem  Build Successfully send mail build_check.html(build_put.xml)
    ant -buildfile D:\\composer8210\\SandBox\\build_bvt.xml -logfile D:\\composer8210\\SandBox\\AllBuildLogs\\build_bvt.log -verbose
    echo build successful!!!

    call D:\\composer8210\\SandBox\\build_complete.bat
    call D:\\composer8210\\SandBox\\build_put.bat
             
     
    rem call D:\\composer8210\\SandBox\\setupenv.bat
		rem call D:\\composer8210\\SandBox\\build_level.bat 
		rem echo level=%level_serialbuild%>>C:\\LocalSettings.properties
    ant -buildfile D:\\composer8210\\SandBox\\sendmail_build_successful.xml -logfile D:\\composer8210\\SandBox\\AllBuildLogs\sendmail.log -verbose
    echo complete level successful!!!
    
	) else (
    rem  Build Failed send fail mail
    ant -buildfile D:\\composer8210\\SandBox\\build_fail.xml
    call D:\\composer8210\\SandBox\\build_level.bat
    echo level=%level_serialbuild%>>C:\\LocalSettings.properties
    ant -buildfile D:\\composer8210\\SandBox\\sendmail_build_failed.xml -logfile D:\\composer8210\\SandBox\\AllBuildLogs\sendmail.log -verbose
    echo build failed!!!
	)
) else(
   ant -buildfile D:\\composer8210\\SandBox\\sendmail_extract_failed.xml -logfile D:\\composer8210\\SandBox\\AllBuildLogs\sendmail.log -verbose
   echo extract build failed!!!
)

rem copy source files to was7 build home then invoke was7 build
rem ant -buildfile D:\\composer8210\\SandBox\\copy_src.xml -logfile D:\\composer8210\\SandBox\\AllBuildLogs\\copy_src.log -verbose
rem call D:\\composer800_was7\\SandBox\\build_bvt.bat    



