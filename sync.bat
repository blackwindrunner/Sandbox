@echo off

cd D:\\composer811\\SandBox
@for /f %%N IN (D:\\composer811\\SandBox\\811_sync.txt) Do @( cd.. & rd %%N /S /Q) & cd SandBox  >D:\\composer811\\SandBox\\AllBuildLogs\\sync_del.log

cd D:\\composer811\\SandBox
call D:\\composer811\\SandBox\\setupenv.bat

@for /f %%N IN (D:\\composer811\\SandBox\\811_sync.txt) Do @(perl -S D:\composer811\SandBox\perl\CMVCExtract_Sync.perl -r composer811 -c %%N -p D:\composer811 >>D:\\composer811\\SandBox\\AllBuildLogs\\sync_cmvcextract.log & cd D:\\composer811\\%%N & md D:\\composer811\\%%N\\logs & ant -buildfile D:\\composer811\\%%N\\build.xml -logfile D:\\composer811\\%%N\\logs\\ant.log -verbose) & cd D:\\composer811\\SandBox
