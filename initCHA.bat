call setupenv.bat
@echo off
cd ..
cd BTTAutomation
ws_ant -f init.xml checkBackends & cd .. & cd sandbox & goto end
