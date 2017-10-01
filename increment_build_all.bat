@echo no

call D:\\BTT_workspace_increment\\SandBox\\setupenv.bat
cd %ENG_WORK_SPACE%\\SandBox
set sandbox_catalog=%ENG_WORK_SPACE%\\SandBox
set propertiesFolder=%ENG_WORK_SPACE%\\SandBox\\properties
set increment_ci_Folder=%ENG_WORK_SPACE%\\SandBox\\increment_ci
rem call %ENG_WORK_SPACE%\\SandBox\\build.bat -c builddse
rem call %ENG_WORK_SPACE%\\SandBox\\build.bat -c buildall

rem 清理文件
rem 删除defect依赖文件文件
call rm %propertiesFolder%\\defectDependCom.properties
rem 删除组件日志文件
cd increment_ci
python %increment_ci_Folder%\\clean.py
rem python %increment_ci_Folder%\\all_comp_dependency.py
cd ..
rem 根据defect所在的组件，来生成组件的依赖组件
@for /f %%a IN (%propertiesFolder%\\defectComponent.properties) Do @(cat %propertiesFolder%\\defectDependCom.properties %ENG_WORK_SPACE%\\%%a\\DependencyComponents.properties | sort | uniq >> %propertiesFolder%\\defectDependCom.properties)
rem 对被依赖的组件解压之前保留的版本  
@for /f %%d IN (%propertiesFolder%\\defectDependCom.properties) Do @(echo extract deliverables **%%d**  &"%ProgramFiles%\\7-Zip\\7z.exe" x -y -o"%ENG_WORK_SPACE%\\%%d" "D:\\8210_deliverables_zip\\%%d.zip" )

rem 被依赖的组件复制jar
call ant -f increment_depend_comp_jars.xml

rem 把依赖的jar循环加入到classpath，用于编译时使用
@setlocal enabledelayedexpansion
@for %%i in ("D:\BTT_workspace_increment\SandBox\increment_jars\*.jar") Do set  classpath=!classpath!;%%i; 
@setlocal disabledelayedexpansion

rem 按defectComponent.properties文件内容包含的组件进行构建，这句的算法需要在论文中体现
@for /f %%N IN (%ENG_WORK_SPACE%\\SandBox\\properties\\defectComponent.properties) Do @(cd .. & cd %%N  & echo. & echo ------%%N BUILD------ & md logs & call ant -buildfile %ENG_WORK_SPACE%\\%%N\\build.xml -logfile %ENG_WORK_SPACE%\\%%N\\logs\\ant.log -verbose) & cd %ENG_WORK_SPACE%\\SandBox


perl -S %ENG_WORK_SPACE%\\SandBox\\perl\\Check_build.perl >>%ENG_WORK_SPACE%\\SandBox\\AllBuildLogs\\check_build.log
rem perl -S %ENG_WORK_SPACE%\\SandBox\\perl\\CheckJavaDoc.pl composer8210
set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.6.0_45\jre
if not exist %ENG_WORK_SPACE%\\SandBox\\AllBuildLogs\\build.fail ( 
	echo build  successful!!!
	echo defect=none> buildResult.txt
	echo buildResult=s>> buildResult.txt
	rem call ant -buildfile %ENG_WORK_SPACE%\\SandBox\\sendmail_build_successful.xml -logfile %ENG_WORK_SPACE%\\SandBox\\AllBuildLogs\sendmail.log -verbose
	echo build successful!!!
	goto successful
) else ( 
	echo build failed!!! 
	echo defect=none> buildResult.txt
	echo buildResult=f>> buildResult.txt	
	rem call ant -buildfile %ENG_WORK_SPACE%\\SandBox\\sendmail_build_failed.xml -logfile %ENG_WORK_SPACE%\\SandBox\\AllBuildLogs\sendmail.log -verbose
	echo build failed!!!
	goto failed
)
:failed
	rem exit 1
:successful
	rem exit 0
:end
  echo.
  echo.