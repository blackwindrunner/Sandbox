@echo off

cd D:\\composer8210\\SandBox

call D:\\composer8210\\SandBox\\setupenv.bat

@for /f %%N IN (D:\\composer8210\\SandBox\\8210.txt) Do @(perl -S D:\composer8210\SandBox\perl\CheckDependenceJar.perl -r composer8210 -c %%N -p D:\composer8210 >>D:\\composer8210\\SandBox\\AllBuildLogs\\AllJars.log) & cd D:\\composer8210\\SandBox