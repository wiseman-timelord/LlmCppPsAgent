@echo off
mode 66,19
title Llama2CppRobot-Launcher


:: Meat of the script starts here!


:: Intro and Current Working Directory
echo ******************************************************************
echo                          MULTI-LAUNCHER
echo ******************************************************************
echo.

:: Run application LlmCppPs-Bot
set "BATCH_DIR=%~dp0"
echo Running, window_1 and window_2...
echo.
echo powershell.exe -Command "Start-Process -Verb RunAs -FilePath '%COMSPEC%' -ArgumentList '/c cd /d ""%BATCH_DIR%"" && powershell.exe -ExecutionPolicy Bypass -File ""%~dp0window_1.ps1""'"
powershell.exe -Command "Start-Process -Verb RunAs -FilePath '%COMSPEC%' -ArgumentList '/c cd /d ""%BATCH_DIR%"" && powershell.exe -ExecutionPolicy Bypass -File ""%~dp0window_1.ps1""'"
echo.
echo powershell.exe -Command "Start-Process -Verb RunAs -FilePath '%COMSPEC%' -ArgumentList '/c cd /d ""%BATCH_DIR%"" && powershell.exe -ExecutionPolicy Bypass -File ""%~dp0window_2.ps1""'"
powershell.exe -Command "Start-Process -Verb RunAs -FilePath '%COMSPEC%' -ArgumentList '/c cd /d ""%BATCH_DIR%"" && powershell.exe -ExecutionPolicy Bypass -File ""%~dp0window_2.ps1""'"
echo.
goto Exit

: Exit
:: Exit the script Normally
echo Exiting Launcher!
echo.
timeout /t 3 /nobreak >nul
echo.
exit
