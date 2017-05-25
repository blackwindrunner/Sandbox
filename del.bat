@echo off
D:
cd D:\\composer8210\\SandBox
echo delete begin
@for /f %%N IN (D:\\composer8210\\SandBox\\8210.txt) Do @( cd .. & rd %%N /S /Q) & cd SandBox  >>D:\\composer8210\\SandBox\\AllBuildLogs\\build_del.log
@for /f %%N IN (D:\\composer8210\\SandBox\\8210_1.txt) Do @( cd .. & rd %%N /S /Q) & cd SandBox  >>D:\\composer8210\\SandBox\\AllBuildLogs\\build_del.log
@for /f %%N IN (D:\\composer8210\\SandBox\\8210_2.txt) Do @( cd .. & rd %%N /S /Q) & cd SandBox  >>D:\\composer8210\\SandBox\\AllBuildLogs\\build_del.log
@for /f %%N IN (D:\\composer8210\\SandBox\\8210_3.txt) Do @( cd .. & rd %%N /S /Q) & cd SandBox  >>D:\\composer8210\\SandBox\\AllBuildLogs\\build_del.log
@for /f %%N IN (D:\\composer8210\\SandBox\\8210_4.txt) Do @( cd .. & rd %%N /S /Q) & cd SandBox  >>D:\\composer8210\\SandBox\\AllBuildLogs\\build_del.log
echo delete end