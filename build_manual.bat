@echo off

cd D:\\composer8210\\SandBox
call D:\\composer8210\\SandBox\\del.bat
perl -S D:\\composer8210\\SandBox\\perl\\CreateLevel_S.perl -r composer8210 -t integration >>D:\\composer8210\\SandBox\\AllBuildLogs\\createLevel.log
call D:\\composer8210\\SandBox\\build.bat -c excbuildall
