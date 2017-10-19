call setupenv.bat
@echo off

if "%1"=="" goto runAllWithBuild

:runAllWithBuild
  set case=%1
  cd ..
  cd BTTAutomation
  ws_ant -f increment_build.xml -Dcategory=fvt -Dcase=%case% -Drebuild=true runFvt & cd .. & cd sandbox 
  goto end

:end
  echo.
  echo.