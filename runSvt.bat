call setupenv.bat
@echo off

if "%1"=="" goto runAllWithNewBuild
if "%1"=="-nobuild" goto runAllWithOldBuild
if not exist ..\BTTAutomation\svt\%1\case.xml goto error
if "%2"=="-nobuild" goto runTestCaseWithOldBuild
goto runTestCaseWithNewBuild



:runTestCaseWithOldBuild
  set case=%1
  cd ..
  cd BTTAutomation
  ws_ant -Dcategory=svt -Dcase=%case% -Drebuild=false runTestCase & cd .. & cd sandbox & goto end
  
  
:runTestCaseWithNewBuild
  set case=%1
  cd ..
  cd BTTAutomation
  ws_ant -Dcategory=svt -Dcase=%case% -Drebuild=true runTestCase & cd .. & cd sandbox & goto end

:runAllWithOldBuild
  set case=%1
  cd ..
  cd BTTAutomation
  ws_ant -Dcategory=svt -Dcase=%case% -Drebuild=false runSvt & cd .. & cd sandbox & goto end
  
:runAllWithNewBuild
  set case=%1
  cd ..
  cd BTTAutomation
  ws_ant -Dcategory=svt -Dcase=%case% -Drebuild=true runSvt & cd .. & cd sandbox & goto end
 
:error
  REM cls
  echo.
  echo.
  echo  %1 is not a valid test case.
  echo  "BTTAutomation\svt\%1\case.xml" does not exist.
  echo.
  echo.
  goto end

:end
  echo.
  echo.