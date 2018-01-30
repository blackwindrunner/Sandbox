@echo off

if "%1"=="" goto nocomponent
if not "%1"=="-c" goto invalidparm

if "%2"=="all" goto serialbuild
if "%2"=="exctest" goto exctestsuite
if "%2"=="excbuildall" goto excbuild
if "%2"=="buildall" goto buildall
if "%2"=="builddse" goto builddse
if "%2"=="excbuilddse" goto excbuilddse
if "%2"=="excbuildother" goto excbuildother
if "%2"=="excbuildgtb" goto excbuildgtb
if "%2"=="refactor" goto refactorbuild
if "%2"=="j9build" goto j9build
if "%2"=="ws7build" goto ws7build
if "%2"=="installbuild" goto installbuild
if not exist ..\%2\build.xml goto invalidcomponent
if "%3"=="" goto localbuild
if "%3"=="-dep" goto dependencies
if not "%3"=="-dep" goto invalidparmdep

:localbuild
  call setupenv.bat
  cd ..
  cd %2
  echo.
  echo ------%2 BUILD------
  md logs
  ant -logfile logs\ant.log -verbose & findstr /i "build successful" logs\ant.log || echo  BUILD FAILED & echo. & cd .. & cd SandBox & goto end

:dependencies
  call setupenv.bat
  @for /f %%N IN (..\%2\dependencies.properties) Do @(cd .. & cd %%N  & echo. & echo ------%%N BUILD------ & md logs & ant -logfile logs\ant.log -verbose & findstr /i "build successful" logs\ant.log || echo BUILD FAILED) & cd .. & cd SandBox
   
:serialbuild
  call setupenv.bat
  del  AllBuildLogs\ant.log
  @for /f %%N IN (8211.txt) Do @(cd .. & cd %%N & echo. & echo ------%%N BUILD------ & md logs  & ant -logfile logs\ant.log -verbose & findstr /i "build successful" logs\ant.log || echo BUILD FAILED & more logs\ant.log >>..\SandBox\AllBuildLogs\ant.log & echo. & echo ----------\SandBox\AllBuildLogs\ant.log) & cd .. & cd SandBox
  
:exctestsuite
  cd %ENG_WORK_SPACE%\\SandBox
  call %ENG_WORK_SPACE%\\SandBox\\setupenv.bat
  call %ENG_WORK_SPACE%\\SandBox\\build_level.bat
  echo level=%level_serialbuild%>>C:\\LocalSettings.properties
  @for /f %%N IN (%ENG_WORK_SPACE%\\SandBox\\%VERSION%_test.txt) Do @(perl -S D:\composer8211\SandBox\perl\CMVCExtract.perl -r composer8211 -c %%N -l %level_serialbuild% -p D:\composer8211 >>%ENG_WORK_SPACE%\\SandBox\\AllBuildLogs\\cmvcextract.log & cd %ENG_WORK_SPACE%\\%%N & md %ENG_WORK_SPACE%\\%%N\\logs & ant -buildfile %ENG_WORK_SPACE%\\%%N\\build.xml -logfile %ENG_WORK_SPACE%\\%%N\\logs\\ant.log -verbose) & cd %ENG_WORK_SPACE%\\SandBox

:excbuilddse
  cd %ENG_WORK_SPACE%\\SandBox
  call %ENG_WORK_SPACE%\\SandBox\\setupenv.bat
  call %ENG_WORK_SPACE%\\SandBox\\build_level.bat
  echo level=%level_serialbuild%>>C:\\LocalSettings.properties
  @for /f %%N IN (%ENG_WORK_SPACE%\\SandBox\\8211_dse.txt) Do @(perl -S D:\composer8211\SandBox\perl\CMVCExtract.perl -r composer8211 -c %%N -l %level_serialbuild% -p D:\composer8211 >>%ENG_WORK_SPACE%\\SandBox\\AllBuildLogs\\cmvcextract.log & cd %ENG_WORK_SPACE%\\%%N & md %ENG_WORK_SPACE%\\%%N\\logs & ant -buildfile %ENG_WORK_SPACE%\\%%N\\build.xml -logfile %ENG_WORK_SPACE%\\%%N\\logs\\ant.log -verbose) & cd %ENG_WORK_SPACE%\\SandBox
	
:excbuild
  cd %ENG_WORK_SPACE%\\SandBox
  call %ENG_WORK_SPACE%\\SandBox\\setupenv.bat
  call %ENG_WORK_SPACE%\\SandBox\\build_level.bat
  echo level=%level_serialbuild%>>C:\\LocalSettings.properties
  @for /f %%N IN (%ENG_WORK_SPACE%\\SandBox\\8211.txt) Do @(perl -S D:\composer8211\SandBox\perl\CMVCExtract.perl -r composer8211 -c %%N -l %level_serialbuild% -p D:\composer8211 >>%ENG_WORK_SPACE%\\SandBox\\AllBuildLogs\\cmvcextract.log & cd %ENG_WORK_SPACE%\\%%N & md %ENG_WORK_SPACE%\\%%N\\logs & ant -buildfile %ENG_WORK_SPACE%\\%%N\\build.xml -logfile %ENG_WORK_SPACE%\\%%N\\logs\\ant.log -verbose) & cd %ENG_WORK_SPACE%\\SandBox
  
:buildall
  call %ENG_WORK_SPACE%\\SandBox\\setupenv.bat
  @for /f %%N IN (%ENG_WORK_SPACE%\\SandBox\\%VERSION%.txt) Do @(cd .. & cd %%N  & echo. & echo ------%%N BUILD------ & md logs & call ant -buildfile %ENG_WORK_SPACE%\\%%N\\build.xml -logfile %ENG_WORK_SPACE%\\%%N\\logs\\ant.log -verbose) & cd %ENG_WORK_SPACE%\\SandBox
  goto end
 
:excbuildother
  cd %ENG_WORK_SPACE%\\SandBox
  call %ENG_WORK_SPACE%\\SandBox\\setupenv.bat
  call %ENG_WORK_SPACE%\\SandBox\\build_level.bat
  echo level=%level_serialbuild%>>C:\\LocalSettings.properties
  @for /f %%N IN (%ENG_WORK_SPACE%\\SandBox\\8211_1.txt) Do @(cd %ENG_WORK_SPACE%\\%%N & md %ENG_WORK_SPACE%\\%%N\\logs & ant -buildfile %ENG_WORK_SPACE%\\%%N\\build.business.template.xml -logfile %ENG_WORK_SPACE%\\%%N\\logs\\ant_build_business_template.log -verbose) & echo. & echo ------BUILD 1------ & cd ../SandBox &   @for /f %%N IN (%ENG_WORK_SPACE%\\SandBox\\8211_2.txt) Do @(perl -S D:\composer8211\SandBox\perl\CMVCExtract.perl -r composer8211 -c %%N -l %level_serialbuild% -p D:\composer8211 >>%ENG_WORK_SPACE%\\SandBox\\AllBuildLogs\\cmvcextract.log & cd %ENG_WORK_SPACE%\\%%N & md %ENG_WORK_SPACE%\\%%N\\logs & ant -buildfile %ENG_WORK_SPACE%\\%%N\\build.xml -logfile %ENG_WORK_SPACE%\\%%N\\logs\\ant.log -verbose) & cd ../SandBox &   @for /f %%N IN (%ENG_WORK_SPACE%\\SandBox\\8211_3.txt) Do @(cd %ENG_WORK_SPACE%\\%%N & md %ENG_WORK_SPACE%\\%%N\\logs & ant -buildfile %ENG_WORK_SPACE%\\%%N\\build.xml -logfile %ENG_WORK_SPACE%\\%%N\\logs\\ant_businesstemplate.log -verbose) & echo. & echo ------BUILD 3------ & cd %ENG_WORK_SPACE%\\SandBox
	
:excbuildgtb
  cd %ENG_WORK_SPACE%\\Sandbox
  call %ENG_WORK_SPACE%\\Sandbox\\setupenvGTB.bat
  call %ENG_WORK_SPACE%\\Sandbox\\build_level.bat
  echo level=%level_serialbuild%>>C:\\LocalSettings.properties
  @for /f %%N IN (%ENG_WORK_SPACE%\\SandBox\\8211_GTB.txt) Do @(cd .. & cd %%N  & echo. & echo ------%%N BUILD------ & md logs & ant -buildfile %ENG_WORK_SPACE%\\%%N\\build.xml -logfile %ENG_WORK_SPACE%\\%%N\\logs\\ant.log -verbose) & cd %ENG_WORK_SPACE%\\SandBox
  
:refactorbuild
  cd %ENG_WORK_SPACE%\\SandBox
  call %ENG_WORK_SPACE%\\SandBox\\setupenv.bat
  call %ENG_WORK_SPACE%\\SandBox\\build_level.bat
  echo level=%level_serialbuild%>>C:\\LocalSettings.properties
  @for /f %%N IN (%ENG_WORK_SPACE%\\SandBox\\8211_ref.txt) Do @(perl -S D:\composer8211\SandBox\perl\CMVCExtract.perl -r composer8211 -c %%N -l %level_serialbuild% -p D:\composer8211 >>%ENG_WORK_SPACE%\\SandBox\\AllBuildLogs\\cmvcextract.log & cd %ENG_WORK_SPACE%\\%%N & md %ENG_WORK_SPACE%\\%%N\\logs & ant -buildfile %ENG_WORK_SPACE%\\%%N\\build.xml -logfile %ENG_WORK_SPACE%\\%%N\\logs\\ant.log -verbose) & cd %ENG_WORK_SPACE%\\SandBox

:j9build
  cd %ENG_WORK_SPACE%\\SandBox
  call %ENG_WORK_SPACE%\\SandBox\\setupenv_J9.bat
  echo Log_info:level=%level_serialbuild%>>C:\\LocalSettings_J9.properties
  @for /f %%N IN (%ENG_WORK_SPACE%\\SandBox\\%VERSION%_J9.txt) Do @(cd .. & cd %%N  & echo. & echo ------%%N BUILD------ & md logs & ant -buildfile %ENG_WORK_SPACE%\\%%N\\build.xml -logfile %ENG_WORK_SPACE%\\%%N\\logs\\ant.log -verbose) & cd %ENG_WORK_SPACE%\\SandBox
  
:builddse
  cd %ENG_WORK_SPACE%\\SandBox
  @for /f %%N IN (%ENG_WORK_SPACE%\\SandBox\\%VERSION%_dse.txt) Do @(cd .. & cd %%N  & echo. & echo ------%%N BUILD------ & md logs & ant -buildfile %ENG_WORK_SPACE%\\%%N\\build.xml -logfile %ENG_WORK_SPACE%\\%%N\\logs\\ant.log -verbose) & cd %ENG_WORK_SPACE%\\SandBox

:ws7build
  cd %ENG_WORK_SPACE%\\SandBox
  call %ENG_WORK_SPACE%\\SandBox\\setupenv_ws7.bat
  call %ENG_WORK_SPACE%\\SandBox\\build_level.bat
  echo level=%level_serialbuild%>>C:\\LocalSettings_ws7.properties
  @for /f %%N IN (%ENG_WORK_SPACE%\\SandBox\\8211_ws7.txt) Do @(cd .. & cd %%N  & echo. & echo ------%%N BUILD------ & md logs & ant -buildfile %ENG_WORK_SPACE%\\%%N\\build.xml -logfile %ENG_WORK_SPACE%\\%%N\\logs\\ant.log -verbose) & cd %ENG_WORK_SPACE%\\SandBox


:installbuild
  cd %ENG_WORK_SPACE%\\SandBox
  call %ENG_WORK_SPACE%\\SandBox\\setupenv.bat
  call %ENG_WORK_SPACE%\\SandBox\\build_level.bat
  echo Log_info:level=%level_serialbuild%>>C:\\LocalSettings.properties
  @for /f %%N IN (%ENG_WORK_SPACE%\\SandBox\\%VERSION%_Install.txt) Do @(cd .. & cd %%N  & echo. & echo ------%%N BUILD------ & md logs & ant -buildfile %ENG_WORK_SPACE%\\%%N\\build.xml -logfile %ENG_WORK_SPACE%\\%%N\\logs\\ant.log -verbose) & cd %ENG_WORK_SPACE%\\SandBox



:invalidparm
REM cls
  echo.
  echo.
  echo    build %1 %2 %3
  echo.
  echo    Error: Invalid parameter %1
  echo.
  echo    USAGE: build -c "component" [-dep]
  echo       or  build -c all
  echo.
  echo.
  goto end
  
:nocomponent
  REM cls
  echo.
  echo.
  echo    build %1 %2 %3
  echo.
  echo    Error: No component specified to build.
  echo.
  echo    USAGE: build -c "component" [-dep]
  echo       or  build -c all
  echo.
  echo.
  echo.
  goto end

:invalidcomponent
  REM cls
  echo.
  echo.
  echo    Error: %2 is not a valid component.
  echo.
  echo    USAGE: build -c "component" [-dep]
  echo       or  build -c all
  echo.
  echo.
  echo.
  goto end
  
:invalidparmdep
REM cls
  echo.
  echo.
  echo    build %1 %2 %3
  echo.
  echo    Error: Invalid parameter %3
  echo.
  echo    USAGE: build -c "component" [-dep]
  echo       or  build -c all
  echo.
  echo.
  goto end

:end
  echo.
  echo.
  
