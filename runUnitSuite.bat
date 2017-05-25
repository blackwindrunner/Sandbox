call setupenv.bat
@echo off

if "%1"=="" goto error
if "%2"=="-nobuild" goto runWithOldBuild
goto runWithNewBuild
 
:runWithOldBuild 
set suite=%1
cd ..
cd BTTAutomation
ant -Dcategory=unit -Dsuite=%suite% -Drebuild=false runUnitTestSuite & cd .. & cd sandbox & goto end

:runWithNewBuild 
set suite=%1
cd ..
cd BTTAutomation
ant -Dcategory=unit -Dsuite=%suite% -Drebuild=true runUnitTestSuite & cd .. & cd sandbox & goto end

:error
  REM cls 
  echo  You should input a valid suite name: CHA, Struts, OPSTEP 
  goto end

:end
  echo.
  echo.