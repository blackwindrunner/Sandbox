@echo off
call setupenv.bat
rem set another environment properties file for Mobile components 
set LOCAL_SETTINGS_FILE_J9=C:\\LocalSettings_J9.properties
rem set ENG_WORK_SPACE=D:\\BTT_workspace_8211
set J9_HOME=D:\\LE6.2\\device\\toolkit-platforms\\win32\\eclipse

rem set WAS_HOME=D:\\WAS7\\AppServer


rem set RAD_HOME=D:\\RAD91\\SDP
rem set RAD_SHARED_HOME=D:\\RAD91\\SDPShared


rem set release=composer8210
rem set ANTVERSION=apache-ant-1.9.3
rem set ANTLOC=C:\\Apache\\apache-ant-1.9.3\\bin
rem setANTLOC=%WAS_HOME%\\deploytool\\itp\\plugins\\org.apache.ant_1.6.5\\bin
rem set EJBDEPLOYED_WAS_HOME=%WAS_HOME%

rem set JAVA_HOME=%WAS_HOME%\\java
set JAVA_HOME=D:\\LE6.2\\device\\toolkit-platforms\\win32\\eclipse\\plugins\\com.ibm.pvc.wece.device.win32.x86_6.2.0.0-20081017\\jre


rem set ITP_LOC=%WAS_HOME%\\deploytool\\itp
set PATH=%ANTLOC%;%WAS_HOME%;%WAS_HOME%\\bin;%JAVA_HOME%\bin;%WAS_HOME%\\deploytool;%PATH%;%J9_HOME%
rem set CLASSPATH=%JAVA_HOME%\lib;%CLASSPATH%;

echo.>%LOCAL_SETTINGS_FILE_J9%
echo # Generated: %DATE% - %TIME%>>%LOCAL_SETTINGS_FILE_J9%
echo.>>%LOCAL_SETTINGS_FILE_J9%
echo # The following properties are specific environment variables for>>%LOCAL_SETTINGS_FILE_J9%
echo # release %release% Ant builds on this machine (%USERDOMAIN%):>>%LOCAL_SETTINGS_FILE_J9%
echo.>>%LOCAL_SETTINGS_FILE_J9%
echo WAS_HOME=%WAS_HOME%>>%LOCAL_SETTINGS_FILE_J9%
echo RAD_HOME=%RAD_HOME%>>%LOCAL_SETTINGS_FILE_J9%
echo RAD_SHARED_HOME=%RAD_SHARED_HOME%>>%LOCAL_SETTINGS_FILE_J9%
echo ENG_WORK_SPACE=%ENG_WORK_SPACE%>>%LOCAL_SETTINGS_FILE_J9%

echo J9_HOME=%J9_HOME%>>%LOCAL_SETTINGS_FILE_J9%
echo JAVA_HOME=%JAVA_HOME%>>%LOCAL_SETTINGS_FILE_J9%
echo java.home=%JAVA_HOME%>>%LOCAL_SETTINGS_FILE_J9%
echo ejbdeployed.was.home=%EJBDEPLOYED_WAS_HOME%>>%LOCAL_SETTINGS_FILE_J9%
echo jars=%ENG_WORK_SPACE%\\SandBox\\jars\\>>%LOCAL_SETTINGS_FILE_J9%


echo Environment setup
echo Success

