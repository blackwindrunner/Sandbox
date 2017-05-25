@echo off

coxpy /e d:\composer811\BTTWeb2JSLib\sourceCode\com\*.* d:\composer811\dojodelta\com\
copy d:\composer811\BTTWeb2JSLib\btt.profile.js d:\composer811\dojodelta\
ant -buildfile D:\\composer811\\DojoDelta\\build.xml -logfile D:\\composer811\\DojoDelta\\ant.log -verbose
  