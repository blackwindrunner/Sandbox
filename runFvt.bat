call setupenv.bat
@echo off

if "%1"=="" goto runAllWithBuild
if "%1"=="-nobuild" goto runAllWithOldBuild
if "%1"=="-nowas" goto runAllTestCaseWithOutWas
if not exist ..\BTTAutomation\fvt\%1\case.xml goto error
if "%2"=="-nobuild" goto runTestCaseWithOldBuild
if "%2"=="-nowas" goto runTestCaseWithOutWas
goto runTestCaseWithBuild


:runTestCaseWithOldBuild
  set case=%1
  cd ..
  cd BTTAutomation
  ws_ant -Dcategory=fvt -Dcase=%case% -Drebuild=false runTestCase & cd .. & cd sandbox 
  goto end
  
:runTestCaseWithOutWas
  set case=%1
  cd ..
  cd BTTAutomation
  ws_ant -Dcategory=fvt -Dcase=%case% -Drebuild=true runFvtCaseWithOutWas & cd .. & cd sandbox 
  goto end
  
:runAllTestCaseWithOutWas
  set case=%1
  cd ..
  cd BTTAutomation
  ws_ant -Dcategory=fvt -Drebuild=true  runAllFvtCaseWithOutWas & cd .. & cd sandbox 
  goto end
  
:runTestCaseWithBuild
  set case=%1
  cd ..
  cd BTTAutomation
  ws_ant -Dcategory=fvt -Dcase=%case% -Drebuild=true runTestCase & cd .. & cd sandbox 
  goto end

:runAllWithBuild
  set case=%1
  cd ..
  cd BTTAutomation
  ws_ant -Dcategory=fvt -Dcase=%case% -Drebuild=true runFvt & cd .. & cd sandbox 
  goto end

:runAllWithOldBuild
  set case=%1
  cd ..
  cd BTTAutomation
  ws_ant -Dcategory=fvt -Dcase=%case% -Drebuild=false runFvt & cd .. & cd sandbox 
  goto end
 
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