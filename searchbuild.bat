@echo off

del  AllBuildLogs\buildsuccess.log
@for /f %%N IN (811.txt) Do @(cd .. & cd %%N & echo %%N & find /i "build successful" logs\ant.log || echo BUILD FAILED & echo.)>>..\SandBox\AllBuildLogs\buildsuccess.log  & cd .. & cd SandBox
