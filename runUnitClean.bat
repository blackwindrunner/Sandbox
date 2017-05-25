call setupenv.bat
@echo off

  cd ..
  cd BTTAutomation
  ws_ant  -Dcategory=unit cleanAll  & cd ..  & cd sandbox & goto end
  echo.
  echo.