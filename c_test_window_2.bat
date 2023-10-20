@echo off
title Llama2CppRobot-Launcher for Window_2

:: Intro and Current Working Directory
echo ********************************************
echo                WINDOW_2 LAUNCHER
echo ********************************************
echo.

:: Run application LlmCppPsBot for window_2
set "BATCH_DIR=%~dp0"
echo Running window_2...
@echo on
pwsh -ExecutionPolicy Bypass -NoLogo -NoProfile -File "%~dp0window_2.ps1"

@echo off
echo.

:Exit
:: Exit the script Normally
echo Exiting Launcher for Window_2!
echo.
timeout /t 3 /nobreak >nul
echo.
pause