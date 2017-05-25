call setupenv.bat
@echo off
cd ..
cd BTTAutomation
call ws_ant -f init.xml & cd .. & cd sandbox & goto end
:end
  echo.
  echo.
