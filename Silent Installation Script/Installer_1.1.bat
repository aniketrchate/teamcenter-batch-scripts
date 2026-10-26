
@echo off
setlocal EnableExtensions

REM =====================================================
REM Teamcenter Installation
REM Installer: Teamcenter Environment Manager (TEM)
REM =====================================================

REM -------- CONFIGURATION ------------------------------
set "MEDIA_ROOT=D:\Tools"
set "TEM_DIR=%MEDIA_ROOT%\tc2506_wntx64"
set "TEM_BAT=%TEM_DIR%\tem.bat"
set "SILENT_XML=%MEDIA_ROOT%\silent.xml"
set "LOG_DIR=C:\2506_Installation_Logs\Logs"
set "LOG_FILE=%LOG_DIR%\TC2506_RAC_Install.log"

REM -------- CREATE LOG DIRECTORY ----------------------
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

if not exist "%LOG_DIR%" (
    echo ERROR: Could not create log directory.
    goto :ERROR_PAUSE
)

echo.
echo =====================================================
echo Teamcenter Installation
echo Started: %DATE% %TIME%
echo =====================================================
echo.

echo [%DATE% %TIME%] Starting installation > "%LOG_FILE%"

REM -------- VALIDATE TEM -------------------------------
if not exist "%TEM_BAT%" (
    echo ERROR: TEM launcher not found:
    echo %TEM_BAT%
    echo ERROR: TEM launcher not found: %TEM_BAT%>>"%LOG_FILE%"
    set "INSTALL_RC=10"
    goto :ERROR_PAUSE
)

REM -------- VALIDATE SILENT XML ------------------------
if not exist "%SILENT_XML%" (
    echo ERROR: Silent configuration XML not found:
    echo %SILENT_XML%
    echo ERROR: Silent XML not found: %SILENT_XML%>>"%LOG_FILE%"
    set "INSTALL_RC=11"
    goto :ERROR_PAUSE
)

REM -------- RUN TEM INSTALLATION -----------------------
cd /d "%TEM_DIR%"

echo Running TEM silent installation...
echo.
echo Command: tem.bat -s "%SILENT_XML%"
echo.
echo Installation output is being written to:
echo %LOG_FILE%
echo.
echo Please wait while the installation runs...
echo.

echo Command: tem.bat -s "%SILENT_XML%">>"%LOG_FILE%"

call "%TEM_BAT%" -s "%SILENT_XML%" >> "%LOG_FILE%" 2>&1

set "INSTALL_RC=%ERRORLEVEL%"

echo.>>"%LOG_FILE%"
echo [%DATE% %TIME%] TEM exit code: %INSTALL_RC%>>"%LOG_FILE%"

if not "%INSTALL_RC%"=="0" (
    echo.
    echo =====================================================
    echo INSTALLATION FAILED
    echo TEM Exit Code: %INSTALL_RC%
    echo =====================================================
    echo.
    echo Check the installation log:
    echo %LOG_FILE%
    goto :ERROR_PAUSE
)

echo [%DATE% %TIME%] TEM process completed.>>"%LOG_FILE%"

echo.
echo =====================================================
echo TEM PROCESS COMPLETED
echo Exit Code: %INSTALL_RC%
echo =====================================================
echo.
echo Log file:
echo %LOG_FILE%
echo.
echo.

goto :END_PAUSE

:ERROR_PAUSE
echo.
echo Script stopped because an error occurred.
echo Log file: %LOG_FILE%
echo.
echo Press any key to close this window...
pause >nul
exit /b %INSTALL_RC%

:END_PAUSE
echo Press any key to close this window...
pause >nul
exit /b 0
