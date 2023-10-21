@echo off
title Llama2CppRobot-Launcher for Window_1

:: Intro and Current Working Directory
echo ********************************************
echo                WINDOW_1 LAUNCHER
echo ********************************************
echo.

:: Run application LlmCppPs-Bot for window_1
set "BATCH_DIR=%~dp0"
echo Running window_1...
@echo on
pwsh -ExecutionPolicy Bypass -NoLogo -NoProfile -File "%~dp0window_1.ps1"
@echo off
echo.

:Exit
:: Exit the script Normally
echo Exiting Launcher for Window_1!
echo.
timeout /t 3 /nobreak >nul
echo.
pause
