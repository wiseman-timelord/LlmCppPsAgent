@echo off
mode 44,22
title LlmCppPs-Bot - Config Fix
setlocal

:: Variables for the files to be deleted and copied
set "config1=.\data\config_1.psd1"
set "config2=.\data\config_2.psd1"
set "configX=.\data\config_X.psd1"
set "backup1=.\data\config_1.bak"
set "backup2=.\data\config_2.bak"
set "backupX=.\data\config_X.bak"

:: Title
echo ============================================
echo             Config_X.Psd1 Fixer         
echo ============================================
echo.

:: Check if config_1.psd1 exists, and if so, delete it
if exist "%config1%" (
    echo Deleting %config1%...
    del "%config1%"
) else (
    echo %config1% does not exist. Skipping delete.
)

:: Check if config_2.psd1 exists, and if so, delete it
if exist "%config2%" (
    echo Deleting %config2%...
    del "%config2%"
) else (
    echo %config2% does not exist. Skipping delete.
)

:: Check if config_X.psd1 exists, and if so, delete it
if exist "%configX%" (
    echo Deleting %configX%...
    del "%configX%"
) else (
    echo %configX% does not exist. Skipping delete.
)

:: Check if config_1.bak exists, and if so, copy it to config_1.psd1
if exist "%backup1%" (
    echo Copying %backup1% to %config1%...
    copy "%backup1%" "%config1%"
) else (
    echo %backup1% does not exist. Skipping copy.
)

:: Check if config_2.bak exists, and if so, copy it to config_2.psd1
if exist "%backup2%" (
    echo Copying %backup2% to %config2%...
    copy "%backup2%" "%config2%"
) else (
    echo %backup2% does not exist. Skipping copy.
)

:: Check if config_X.bak exists, and if so, copy it to config_X.psd1
if exist "%backup1%" (
    echo Copying %backupX% to %configX%...
    copy "%backupX%" "%configX%"
) else (
    echo %backupX% does not exist. Skipping copy.
)


:: Done
echo.
echo Done.

:: 5-second timeout before exiting
echo.
echo Exiting in 5 seconds...
timeout /t 5 /nobreak >nul

endlocal
