@echo off

call D:\\composer8210\\SandBox\\setupenv.bat
call D:\\composer8210\\SandBox\\build_level.bat
echo level=%level_serialbuild%>>C:\\LocalSettings.properties

perl -S D:\\composer8210\\SandBox\\perl\\CompleteLevel.perl -r composer8210 -l %level_serialbuild% >>D:\\composer8210\\SandBox\\AllBuildLogs\\CompleteLevel.log

rem perl -S D:\\composer8210\\SandBox\\perl\\CreateDefectReport.perl -r composer8210 -l %level_serialbuild% >D:\\composer8210\\SandBox\\AllBuildLogs\\DefectReport\\%level_serialbuild%_was7.txt

perl -S D:\\composer8210\\SandBox\\perl\\DefectRegressionAdviser.pl -r composer8210 -l %level_serialbuild% -f D:\\composer8210\\SandBox\\perl\\BTT811FuntionDomain.xls > D:\\composer8210\\SandBox\\AllBuildLogs\\DefectReport\\%level_serialbuild%_was7.txt