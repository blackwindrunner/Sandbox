call setupenv.bat
@echo off

  cd ..
  cd BTTAutomation
  ws_ant  -Dcategory=fvt cleanAll  & cd .. & cd .. & cd sandbox & goto end
  echo.
  echo.