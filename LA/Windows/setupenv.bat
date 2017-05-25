@echo off

set BTT_HOME=C:\SandBox
set WAS_HOME=D:\IBM\WAS6ND\AppServer

set release=composer612
set ENG_WORK_SPACE=%BTT_HOME%\%release%

rem for mobile cases
set TOOLKIT_PLATFORM=D:\IBM\LE62\toolkit-platforms\win32\eclipse\plugins\com.ibm.pvc.wece.device.win32.x86_6.2.0.0-20081017\jre

rem set RAD_HOME=C:\RAD70\SDP70
rem set RAD_SHARED_HOME=C:\RAD70\SDP70Shared
rem set ANTVERSION=apache-ant-1.6.5

set ANTLOC=%WAS_HOME%\deploytool\itp\plugins\org.apache.ant_1.6.5\bin
set EJBDEPLOYED_WAS_HOME=%WAS_HOME%
set JAVA_HOME=%WAS_HOME%\java
set ITP_LOC=%WAS_HOME%\deploytool\itp
set PATH=%ANTLOC%;%WAS_HOME%;%WAS_HOME%\bin;%JAVA_HOME%\bin;%WAS_HOME%\deploytool;%PATH%
set CLASSPATH=%JAVA_HOME%\lib;%CLASSPATH%
set LOCAL_SETTINGS_FILE=C:\LocalSettings.properties

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
echo java.home=%JAVA_HOME%>>%LOCAL_SETTINGS_FILE%
echo ejbdeployed.was.home=%EJBDEPLOYED_WAS_HOME%>>%LOCAL_SETTINGS_FILE%
echo jars=%ENG_WORK_SPACE%\SandBox\jars\>>%LOCAL_SETTINGS_FILE%
echo Environment setup
echo Success
