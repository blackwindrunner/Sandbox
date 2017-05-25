@echo off

set ENG_WORK_SPACE=D:\\BTT_workspace
set BTT_BUILD=D:\\BTT_workspace
set WAS_HOME=D:\\WAS7\\AppServer

set RAD_HOME=D:\\RAD91\\RADSE
set RAD_SHARED_HOME=D:\\RAD91\\SDPShared
set J9_HOME=D:\\LE6.2\\device\\toolkit-platforms\\win32\\eclipse

set release=composer8210
set ANTVERSION=apache-ant-1.9.3
set ANTLOC=C:\\Apache\\apache-ant-1.9.3\\bin

set EJBDEPLOYED_WAS_HOME=%WAS_HOME%

set JAVA_HOME=%WAS_HOME%\\java

set TOOLKIT_PLATFORM=%J9_HOME%\\plugins\\com.ibm.pvc.wece.device.win32.x86_6.2.0.0-20081017\\jre

set ITP_LOC=%WAS_HOME%\\deploytool\\itp
set PATH=%ANTLOC%;%WAS_HOME%;%WAS_HOME%\\bin;%JAVA_HOME%\bin;%WAS_HOME%\\deploytool;%PATH%;%J9_HOME%
set CLASSPATH=%JAVA_HOME%\lib;%CLASSPATH%
set LOCAL_SETTINGS_FILE=C:\\LocalSettings.properties
echo.>%LOCAL_SETTINGS_FILE%
echo # Generated: %DATE% - %TIME%>>%LOCAL_SETTINGS_FILE%
echo.>>%LOCAL_SETTINGS_FILE%
echo # The following properties are specific environment variables for>>%LOCAL_SETTINGS_FILE%
echo # release %release% Ant builds on this machine (%USERDOMAIN%):>>%LOCAL_SETTINGS_FILE%
echo.>>%LOCAL_SETTINGS_FILE%
echo WAS_HOME=%WAS_HOME%>>%LOCAL_SETTINGS_FILE%
echo RAD_HOME=%RAD_HOME%>>%LOCAL_SETTINGS_FILE%
echo RAD_SHARED_HOME=%RAD_SHARED_HOME%>>%LOCAL_SETTINGS_FILE%
echo ENG_WORK_SPACE=%ENG_WORK_SPACE%>>%LOCAL_SETTINGS_FILE%
echo J9_HOME=%J9_HOME%>>%LOCAL_SETTINGS_FILE%
echo JAVA_HOME=%JAVA_HOME%>>%LOCAL_SETTINGS_FILE%
echo java.home=%JAVA_HOME%>>%LOCAL_SETTINGS_FILE%
echo TOOLKIT_PLATFORM=%TOOLKIT_PLATFORM%>>%LOCAL_SETTINGS_FILE%
echo ejbdeployed.was.home=%EJBDEPLOYED_WAS_HOME%>>%LOCAL_SETTINGS_FILE%
echo jars=%ENG_WORK_SPACE%\\SandBox\\jars>>%LOCAL_SETTINGS_FILE%
echo Environment setup
echo Success
