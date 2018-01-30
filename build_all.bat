@echo off
call setupenv.bat

cd %ENG_WORK_SPACE%\\SandBox

rem call %ENG_WORK_SPACE%\\SandBox\\build.bat -c builddse
echo Log_info:build buildall
call %ENG_WORK_SPACE%\\SandBox\\build.bat -c buildall
echo Log_info:build j9
call %ENG_WORK_SPACE%\\SandBox\\build.bat -c j9build
echo Log_info:build install
call %ENG_WORK_SPACE%\\SandBox\\build.bat -c installbuild
echo Log_info:build updateSite
call %ENG_WORK_SPACE%\\SandBox\\updateSite.bat
echo Log_info:exec perl check build
perl -S %ENG_WORK_SPACE%\\SandBox\\perl\\Check_build.perl >>%ENG_WORK_SPACE%\\SandBox\\AllBuildLogs\\check_build.log
rem perl -S %ENG_WORK_SPACE%\\SandBox\\perl\\CheckJavaDoc.pl composer8210
set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.6.0_45\jre
if not exist %ENG_WORK_SPACE%\\SandBox\\AllBuildLogs\\build.fail ( 
	echo Log_info:build  successful!!!
	echo Log_info:defect=none> buildResult.txt
	echo Log_info:buildResult=s>> buildResult.txt
	call ant -buildfile %ENG_WORK_SPACE%\\SandBox\\sendmail_build_successful.xml -logfile %ENG_WORK_SPACE%\\SandBox\\AllBuildLogs\sendmail.log -verbose
	echo Log_info:build successful!!!
	goto successful
) else ( 
	echo Log_info:build failed!!! 
	echo Log_info:defect=none> buildResult.txt
	echo Log_info:buildResult=f>> buildResult.txt	
	call ant -buildfile %ENG_WORK_SPACE%\\SandBox\\sendmail_build_failed.xml -logfile %ENG_WORK_SPACE%\\SandBox\\AllBuildLogs\sendmail.log -verbose
	echo Log_info:build failed!!!
	goto failed
)
:failed
	exit 1
:successful
	exit 0
:end
  echo.
  echo.