@echo off
cd D:\\composer8210\\SandBox
call D:\\composer8210\\SandBox\\setupenv.bat
call D:\\composer8210\\SandBox\\build_level.bat
echo level=%level_serialbuild%>>C:\\LocalSettings.properties

ant -buildfile D:\\composer8210\\SandBox\\build_put.xml -logfile D:\\composer8210\\SandBox\\AllBuildLogs\build_put.log -verbose 