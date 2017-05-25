@echo off 
rem Gather all runtime platform automation results and generate email summary report and send them to recipents

echo ******************************************************************************
echo *Gather automation result, generate summary report and sent them to recipents*
echo ******************************************************************************

rem args for generate summary report
set RESULT_DIRECTORY="F:/AutomationResult/Platforms"
set SUMMARY_REPORT_DIR="F:/AutomationResult/SummaryReports"
set PLATFORM_DIR_PATTERN="RTE"
set COVERAGE_FILE="F:/AutomationResult/Coverage/coverage.xml"
set BUILD_LEVEL_FILE="F:/AutomationResult/buildlevel.properties"

rem check if the build level file exist?
if NOT EXIST %BUILD_LEVEL_FILE% (
  echo Build level file does not exist, terminating batch.
  goto end
) ELSE (
  echo Build level file exist,sending e-mail.
)

rem args for send automation report
set MAIL_RECIPENTS="stlv@cn.ibm.com"
set MAIL_FROM="stlv@cn.ibm.com"
set MAIL_SUBJECT="Automation Result Summary Report"
set MAIL_CONTENT=%SUMMARY_REPORT_DIR%/SummaryReport.html

rem environments for generate summary report
rem set JAVA_HOME="D:\IBM\WebSphere\AppServer61\java"
rem set PATH=%JAVA_HOME%\bin;%PATH%

rem suppose all automation results had been send to local directory successfully
rem step1: generate summary report
echo -=* Begin to gererate summary report from automation results gathered from all platforms *=-
java -Xms64m -Xmx256m -cp lib\dom4j-1.6.1.jar;lib\jaxen-1.1.1.jar;lib\TestUtil.jar com.ibm.btt.test.GenerateSummaryReport %RESULT_DIRECTORY% %SUMMARY_REPORT_DIR% %PLATFORM_DIR_PATTERN% %COVERAGE_FILE% %BUILD_LEVEL_FILE% 
echo -=* Gererated summary report.  *=-

rem step2: send summary report to recipents
echo -=* Begin to send the summary report to recipents *=-
STAF LOCAL EMAIL SEND TO %MAIL_RECIPENTS% TO stlv@cn.ibm.com FROM %MAIL_FROM% NORESOLVEMESSAGE NOHEADER CONTENTTYPE text/html SUBJECT %MAIL_SUBJECT% FILE %MAIL_CONTENT%
echo -=* The summary report had been sent. *=-

rem step3: delete all automation results except generated summary report
echo -=* Begin to delete all automation results except generated summary report *=-
del /Q /S %RESULT_DIRECTORY%\*.xml
echo -=* All automation results except generated summary report had been deleted. *=-

:end
echo .
