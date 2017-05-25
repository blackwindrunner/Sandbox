call setupenv.bat
@echo off

if "%1"=="" goto runAllWithBuild
if "%1"=="-nobuild" goto runAllWithOldBuild
if "%1"=="-usewas" goto runAllUnitTestCaseWithWas
if not exist ..\BTTAutomation\unit\%1\case.xml goto error
if "%2"=="-nobuild" goto runTestCaseWithOldBuild
if "%2"=="-usewas" goto runUnitTestCaseWithWas
goto runTestCaseWithBuild



:runTestCaseWithOldBuild
  set case=%1
  cd ..
  cd BTTAutomation
  ant -Dcategory=unit -Dcase=%case% -Drebuild=false runUnitTestCase & cd .. & cd sandbox & goto end
:runUnitTestCaseWithWas
  set case=%1
  cd ..
  cd BTTAutomation
  ws_ant -Dcategory=unit -Dcase=%case% -Drebuild=true runUnitTestCaseWithWas & cd .. & cd sandbox & goto end  
  
:runTestCaseWithBuild
  set case=%1
  cd ..
  cd BTTAutomation
  ant -Dcategory=unit -Dcase=%case% -Drebuild=true runUnitTestCase & cd .. & cd sandbox & goto end
:runAllUnitTestCaseWithWas
  set case=%1
  cd ..
  cd BTTAutomation
  ws_ant -Dcategory=unit -Dcase=%case% -Drebuild=true runAllUnitTestCaseWithWas & cd .. & cd sandbox & goto end
:runAllWithBuild
  set case=%1
  cd ..
  cd BTTAutomation
  ant -Dcategory=unit -Drebuild=true  runAllUnit & cd .. & cd sandbox & goto end
  
:runAllWithOldBuild
  set case=%1
  cd ..
  cd BTTAutomation
  ant -Dcategory=unit -Drebuild=false  runAllUnit & cd .. & cd sandbox & goto end
 
:error
  REM cls
  echo.
  echo.
  echo  %1 is not a valid test case.
  echo  "BTTAutomation\unit\%1\case.xml" does not exist.
  echo.
  echo.
  goto end

:end
  echo.
  echo.