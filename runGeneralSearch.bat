call setupenv.bat
@echo off

  cd ..
  cd BTTAutomation
  ws_ant GeneralSearch  & cd ..  & cd sandbox & goto end
  echo.
  echo.