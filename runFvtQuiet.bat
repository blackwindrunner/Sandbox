call setupenv.bat
@echo off

if "%1"=="" goto runAll
if exist ..\BTTAutomation\fvt\%1\case.xml goto runTestCase
if not exist ..\BTTAutomation\fvt\%1\case.xml goto error

:runTestCase
  set case=%1
  cd ..
  cd BTTAutomation
  ws_ant -Dcategory=fvt -Dcase=%case% -logfile ant.log -verbose runTestCase & cd .. & cd sandbox & goto end

:runAll
  set case=%1
  cd ..
  cd BTTAutomation
  ws_ant -Dcategory=fvt -Dcase=%case% -logfile ant.log -verbose & cd .. & cd sandbox & goto end
 
:error
  REM cls
  echo.
  echo.
  echo  %1 is not a valid test case.
  echo  "BTTAutomation\fvt\%1\case.xml" does not exist.
  echo.
  echo.
  goto end

:end
  echo.
  echo.