@echo off
cd %ENG_WORK_SPACE%\\SandBox
call %ENG_WORK_SPACE%\\SandBox\\setupenv.bat
call %ENG_WORK_SPACE%\\SandBox\\build_level.bat
echo level=%level_serialbuild%>>C:\\LocalSettings.properties

ant -buildfile %ENG_WORK_SPACE%\\SandBox\\build_put.xml -logfile %ENG_WORK_SPACE%\\SandBox\\AllBuildLogs\\build_put.log -verbose 