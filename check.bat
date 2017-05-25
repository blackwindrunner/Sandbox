@echo off

perl -S D:\\composer8210\\SandBox\perl\\Check_build.perl & if not exist D:\\composer8210\\SandBox\\AllBuildLogs\\build.fail (ant -buildfile D:\\composer8210\\SandBox\\build_bvt.xml -logfile D:\\composer8210\\SandBox\\AllBuildLogs\\build_bvt.log -verbose) else (ant -buildfile D:\\composer8210\\SandBox\\build_fail.xml)
