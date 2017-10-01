@echo off
  set defectEnv=D:\\defect8204
  set bttAutomationEnv=%defectEnv%\BTTAutomation
  set "defectEnvForCMVC=%defectEnv:\\=\%"
  set sandboxEnv=%defectEnv%\\SandBox
  set propertiesFolder=%defectEnv%\\SandBox\\properties
  call %sandboxEnv%\\setupenv.bat >> %sandboxEnv%\\AllBuildLogs\\setupenv.log
  rem clean workspace
  
  @for /f %%c IN (%sandboxEnv%\\8204.txt) Do @(cd %defectEnv% & if exist %%c (echo remove folder: %%c & rd /s /q %defectEnv%\\%%c)) & cd %sandboxEnv%
  rd /s /q D:\defect8204\BTTAutomation\update
  rem some components' build depend on other components' deliverables, so unzip the deliverables
  echo "*****************extract base fils begin**********" 
  @for /f %%d IN (%sandboxEnv%\\8204.txt) Do @(echo extract deliverables **%%d**  &"%ProgramFiles%\\7-Zip\\7z.exe" x -y -o"%defectEnv%\\%%d" "D:\\8204_deliverables_zip\\%%d.zip" )
  
  echo.>%propertiesFolder%\\defectDependCom.properties
  
  rem get defect fix record related component name
  Report -general FixView -where "defectname in ('%2') and releasename in ('%1')" -select compName >%propertiesFolder%\\defectComponent.properties
  cd %sandboxEnv%
  
  rem unzip defect fix record related component , general defectDependCom.properties who contains defectDependComponent and dependency of current component.
  @for /f %%a IN (%propertiesFolder%\\defectComponent.properties) Do @("%ProgramFiles%\\7-Zip\\7z.exe" x -y -o"%defectEnv%\\%%a" "D:\\composer8204_zip\\%%a.zip" & cat %propertiesFolder%\\defectDependCom.properties %defectEnv%\\%%a\\dependencies.properties | sort | uniq >> %propertiesFolder%\\defectDependCom.properties)
  rem unzip the dependency component 
  @for /f %%b IN (%propertiesFolder%\\defectDependCom.properties) Do @("%ProgramFiles%\\7-Zip\\7z.exe" x -y -o"%defectEnv%\\%%b" "D:\\composer8204_zip\\%%b.zip")
  echo "*****************extract base fils end**********" 
  echo "*****************extract defect files begin**********" 
  rem extract defect changes file
  track -extract -defect %2 -release %1 -node direct -root %defectEnvForCMVC% -family btt@9.123.123.194@8765 >> %sandboxEnv%\\AllBuildLogs\\defectFileExtract.log
  echo "*****************extract defect files end**********" 
  echo "*****************build component begin**********" 
  @for /f %%N IN (%propertiesFolder%\\defectDependCom.properties) Do @(cd %defectEnv% & if exist %%N\\build.xml (md %defectEnv%\\%%N\\logs & call ant -buildfile %defectEnv%\\%%N\\build.xml -logfile %defectEnv%\\%%N\\logs\\ant.log -verbose))
  echo "*****************build component end**********" 
  echo "build complete"
  perl -S %sandboxEnv%\\perl\\Check_build.perl >%sandboxEnv%\\AllBuildLogs\\check_build.log
  copy %sandboxEnv%\\AllBuildLogs\\build_check.html D:\\temp\\build_check.html
  if not exist %sandboxEnv%\\AllBuildLogs\\build.fail (
	echo build  successful!!!
	rem call ant -buildfile %sandboxEnv%\\sendmail_build_successful.xml -Ddefect=%2 -DbuildResult=successful -DtestResult=successful -logfile %sandboxEnv%\\AllBuildLogs\sendmail.log 
	echo defect=%2> buildResult.txt
	echo buildResult=s>> buildResult.txt
	) else (
		echo build failed!!! 
		echo defect=%2> buildResult.txt
		echo buildResult=f>> buildResult.txt
		call ant -buildfile %sandboxEnv%\\sendmail_build_failed.xml -Ddefect=%2 -DbuildResult=falied -DtestResult=unknown -logfile %sandboxEnv%\\AllBuildLogs\sendmail.log -verbose
		goto failed
    )
:failed
	exit 1
:end
  echo.
  echo.
  