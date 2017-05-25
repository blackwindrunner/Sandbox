@echo off

@for /f %%N IN (D:\\composer811\\SandBox\\811_ref.txt) Do @( cd .. & rd %%N /S /Q) & cd SandBox  >D:\\composer811\\SandBox\\AllBuildLogs\\build_del.log