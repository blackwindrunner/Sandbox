call setupenv.bat
@echo off

  cd ..
  cd BTTAutomation
  ws_ant  -Dcategory=svt cleanAll  & cd .. & cd .. & cd config & goto end
  echo.
  echo.