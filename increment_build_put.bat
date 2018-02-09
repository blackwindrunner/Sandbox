@echo off
cd %ENG_WORK_SPACE%\\SandBox
call %ENG_WORK_SPACE%\\SandBox\\setupenv.bat
call %ENG_WORK_SPACE%\\SandBox\\increment_build_level.bat
echo level=%level_serialbuild%>>C:\\LocalSettings.properties
net use y: /del
net use y: \\10.200.0.188\D$\www\wsbc "Xinmima11" /user:"administrator"
ant -buildfile %ENG_WORK_SPACE%\\SandBox\\increment_build_put.xml -logfile %ENG_WORK_SPACE%\\SandBox\\AllBuildLogs\\increment_build_put.log -verbose 