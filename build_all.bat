@echo off

call D:\\BTT_workspace\\SandBox\\setupenv.bat
cd %ENG_WORK_SPACE%\\SandBox

rem call %ENG_WORK_SPACE%\\SandBox\\build.bat -c builddse
call %ENG_WORK_SPACE%\\SandBox\\build.bat -c buildall
echo test1
call %ENG_WORK_SPACE%\\SandBox\\build.bat -c j9build
echo test2
call %ENG_WORK_SPACE%\\SandBox\\build.bat -c installbuild
call %ENG_WORK_SPACE%\\SandBox\\updateSite.bat
perl -S %ENG_WORK_SPACE%\\SandBox\\perl\\Check_build.perl >>%ENG_WORK_SPACE%\\SandBox\\AllBuildLogs\\check_build.log
rem perl -S %ENG_WORK_SPACE%\\SandBox\\perl\\CheckJavaDoc.pl composer8210
set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.6.0_45\jre
if not exist %ENG_WORK_SPACE%\\SandBox\\AllBuildLogs\\build.fail ( 
	echo build  successful!!!
	echo defect=none> buildResult.txt
	echo buildResult=s>> buildResult.txt
	call ant -buildfile %ENG_WORK_SPACE%\\SandBox\\sendmail_build_successful.xml -logfile %ENG_WORK_SPACE%\\SandBox\\AllBuildLogs\sendmail.log -verbose
	echo build successful!!!
) else ( 
	echo build failed!!! 
	echo defect=none> buildResult.txt
	echo buildResult=f>> buildResult.txt	
	call ant -buildfile %ENG_WORK_SPACE%\\SandBox\\sendmail_build_failed.xml -logfile %ENG_WORK_SPACE%\\SandBox\\AllBuildLogs\sendmail.log -verbose
	echo build failed!!!
	goto failed
)
:failed
	exit 1
:end
  echo.
  echo.