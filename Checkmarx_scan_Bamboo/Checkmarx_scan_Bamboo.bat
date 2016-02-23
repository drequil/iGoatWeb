@echo off
REM Version 0.4
set PRESET=All
set EXCLUDE=test_CX
set temp=%WINDIR%\TEMP
set tmp=%WINDIR%\TEMP
:initial
if [%1]==[-p] goto  lpresetname
if [%1]==[-e] goto  lexcludename
if [%1]==[]   goto  main



:main
set USERNAME=%login%
set PASSWORD=%password%
set Cx_PATH=%cx_path%
set CHECKMARX_HOST=xxxxxxxx
set HIGH_VULNERABILITY_THRESHOLD=1000
set MEDIUM_VULNERABILITY_THRESHOLD=5000


rem It is recommended to add Java/bin and CxConsole folders in the PATH.
set CX_CONSOLE_PATH=C:\tools\checkmarx\CxConsole_CI\CxConsole_CI
set JAVA_HOME=C:\Program Files (x86)\Java\jre7

IF not defined PRESET    set PRESET=All
IF not defined WORKSPACE set WORKSPACE=C:\tmp\CXfoldertoscan\CxDemo\src\com\cx\demo
IF not defined JOB_NAME set JOB_NAME%=CxServer\SP\Company\Users


set PATH=%JAVA_HOME%/bin;%PATH%
set CPATH=.;../config/cx_console.properties;
set CxCONSOLE_COMMAND_PATH=%CX_CONSOLE_PATH%\runCxConsole.cmd
set MSXSL_COMMAND_PATH=%CX_CONSOLE_PATH%\msxsl.exe
set XSLT_HTML_OUTPUT=%CX_CONSOLE_PATH%\CxResult.xslt
set CxParseXMLResults_COMMAND_PATH=%CX_CONSOLE_PATH%\CxParseXMLResults.exe
IF EXIST "%WORKSPACE%\%JOB_NAME%_CXresults.html" del "%WORKSPACE%\%JOB_NAME%_CXresults.html"
IF EXIST "%WORKSPACE%\%JOB_NAME%_CXresults.pdf" del "%WORKSPACE%\%JOB_NAME%_CXresults.pdf"
IF EXIST "%WORKSPACE%\%JOB_NAME%_CXresult.xml" del "%WORKSPACE%\%JOB_NAME%_CXresult.xml"
echo "%CxCONSOLE_COMMAND_PATH%" Scan -CxPassword %PASSWORD% -CxServer %CHECKMARX_HOST% -CxUser %USERNAME% -ProjectName %Cx_PATH%\%JOB_NAME% -Preset %PRESET% -LocationType folder -locationpath "%WORKSPACE%" -reportxml "%WORKSPACE%\%JOB_NAME%_CXresult.xml" -reportpdf "%WORKSPACE%\%JOB_NAME%_CXresults.pdf" -locationpathexclude "%EXCLUDE%" -v
call "%CxCONSOLE_COMMAND_PATH%" Scan -CxPassword %PASSWORD% -CxServer %CHECKMARX_HOST% -CxUser %USERNAME% -ProjectName %Cx_PATH%\%JOB_NAME% -Preset %PRESET% -LocationType folder -locationpath "%WORKSPACE%" -reportxml "%WORKSPACE%\%JOB_NAME%_CXresult.xml" -reportpdf "%WORKSPACE%\%JOB_NAME%_CXresults.pdf" -locationpathexclude "%EXCLUDE%" -v
IF not errorlevel 0  exit /b %ERRORLEVEL%
IF EXIST "%WORKSPACE%\%JOB_NAME%_CXresult.xml" "%MSXSL_COMMAND_PATH%" "%WORKSPACE%\%JOB_NAME%_CXresult.xml" "%XSLT_HTML_OUTPUT%" -o "%WORKSPACE%\%JOB_NAME%_CXresults.html"
IF EXIST "%WORKSPACE%\%JOB_NAME%_CXresult.xml" "%CxParseXMLResults_COMMAND_PATH%" "%WORKSPACE%\%JOB_NAME%_CXresult.xml" %HIGH_VULNERABILITY_THRESHOLD% %MEDIUM_VULNERABILITY_THRESHOLD%
goto finish


:lpresetname
shift
set PRESET=%1
shift
goto initial

:lexcludename
shift
set EXCLUDE=%EXCLUDE%,%1
shift
goto initial



:finish
