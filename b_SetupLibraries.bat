@echo off
mode 56,33
title LlmCppPs-Bot Setup
setlocal enabledelayedexpansion

:: Title
echo =======================================================
echo                     SETUP LIBRARIES  
echo =======================================================
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo                    Startup Processes
echo -------------------------------------------------------

:: Get dir
set "currentDir=!cd!"
echo Working: !currentDir!

:: Check for admin privileges
net session >nul 2>&1
if %errorLevel% == 0 (goto gotAdmin) else (goto requestAdmin)

:requestAdmin
:: Request administrative privileges
set "params=/c cd /d !currentDir! && %0"
powershell -Command "Start-Process cmd.exe -Verb RunAs -ArgumentList '!params!'"
exit /b

:gotAdmin
echo Running with Admin rights.

:: Check if window_1.ps1 or window_2.ps1 is running
for /f "tokens=*" %%a in ('wmic process where "name='powershell'" get CommandLine /VALUE 2^>nul ^| findstr /i "window_1.ps1 window_2.ps1"') do (
    echo ERROR: Close window_1/window_2 first.
    echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++
    goto Exit
)
echo Window_1/Window_2 are closed.

:: Check Powershell => 3.0
for /f "tokens=*" %%a in ('powershell -Command "$PSVersionTable.PSVersion.Major"') do (
    set psVersion=%%a
)
set isValidVersion=0
for %%v in (3 4 5 6 7 8) do (
    if "!psVersion!"=="%%v" (
        set isValidVersion=1
		echo PowerShell Version: !psVersion!
    )
)
if "!isValidVersion!"=="0" (
    echo Incompatible PowerShell: !psVersion!
    pause
    exit
)

:: Empty Cache Folder
pushd .\cache
for %%F in (*) do if not "%%F"=="placeholder" del /F /Q "%%F"
for /D %%D in (*) do rmdir /S /Q "%%D"
echo Cache Folder Cleaned.
popd

echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++


:: Proceed with the script
:: Llama.Cpp menu 1
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo                   CPU Selection Menu
echo -------------------------------------------------------
echo                   1. AMD   (Avx 1)
echo                   2. AMD   (Avx 2)
echo                   3. AMD   (Avx 512)
echo                   4. Other (Non-Avx)
set /p cpuChoice="Select a CPU type: "
if not "!cpuChoice!" geq "1" if not "!cpuChoice!" leq "4" (
    echo Invalid choice, exiting.
    exit /b
)
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++

:: Llama.Cpp menu 2
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo                   GPU Selection Menu
echo -------------------------------------------------------
echo                  1. AMD    (ClBlast)
echo                  2. nVidia (CuBlas 11)
echo                  3. nVidia (CuBlas 12)
echo                  4. Other  (OpenBlas)
set /p gpuChoice="Select a GPU type: "
if not "!gpuChoice!" geq "1" if not "!gpuChoice!" leq "4" (
    echo Invalid choice, exiting.
    exit /b
)
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++

:: Map choices to URLs
set baseUrl=https://github.com/ggerganov/llama.cpp/releases/download/b1261/
set "cpuUrl[1]=!baseUrl!llama-b1261-bin-win-avx-x64.zip"
set "cpuUrl[2]=!baseUrl!llama-b1261-bin-win-avx2-x64.zip"
set "cpuUrl[3]=!baseUrl!llama-b1261-bin-win-avx512-x64.zip"
set "cpuUrl[4]=!baseUrl!llama-b1261-bin-win-noavx-x64.zip"
set "gpuUrl[1]=!baseUrl!llama-b1261-bin-win-clblast-x64.zip"
set "gpuUrl[2]=!baseUrl!llama-b1261-bin-win-cublas-cu11.7.1-x64.zip"
set "gpuUrl[3]=!baseUrl!llama-b1261-bin-win-cublas-cu12.2.0-x64.zip"
set "gpuUrl[4]=!baseUrl!llama-b1261-bin-win-openblas-x64.zip"

:: Download Powershell_7_Core
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo              Download + Extract Ps 7 Core
echo -------------------------------------------------------
for /f "tokens=2 delims==" %%a in ('wmic os get osarchitecture /value') do (
    set "psArch=%%a"
)
for /f "tokens=* delims= " %%a in ("!psArch!") do set "psArch=%%a"
echo !psArch! | findstr /i "32-bit" >nul
if errorlevel 0 (
    set "psArch=x86"
    echo Architecture: 32-bit
) else (
    echo !psArch! | findstr /i "64-bit" >nul
    if errorlevel 0 (
        set "psArch=x64"
        echo Architecture: 64-bit
    ) else (
        echo !psArch! | findstr /i "ARM64" >nul
        if errorlevel 0 (
            set "psArch=arm64"
            echo Architecture: ARM64
        ) else (
            echo !psArch! | findstr /i "ARM" >nul
            if errorlevel 0 (
                set "psArch=arm32"
                echo Architecture: ARM32
            ) else (
                echo Error: Unable To Detect Architecture
                pause
                exit /b
            )
        )
    )
)
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/PowerShell/PowerShell/releases/download/v7.3.8/PowerShell-7.3.8-win-!psArch!.zip' -OutFile '.\cache\ps_core.zip'"
echo Extracting PowerShell 7 Core to .\libraries\ps_core\...
powershell -Command "Expand-Archive -Path .\cache\ps_core.zip -DestinationPath .\libraries\ps_core -Force"
echo PowerShell 7 Core Extracted.
pause
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++

:: Download Llama.Cpp
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo             Download + Extract Llama.Cpp
echo -------------------------------------------------------
.\libraries\ps_core\pwsh -Command "Invoke-WebRequest -Uri '!cpuUrl[!cpuChoice!]!' -OutFile '.\cache\cpu.zip'"
.\libraries\ps_core\pwsh -Command "Invoke-WebRequest -Uri '!gpuUrl[!gpuChoice!]!' -OutFile '.\cache\gpu.zip'"
for %%A in (.\cache\cpu.zip) do set cpuSize=%%~zA
set /a cpuSizeMB=!cpuSize! / 1024 / 1024
echo CPU downloaded, size: !cpuSizeMB!MB
for %%A in (.\cache\gpu.zip) do set gpuSize=%%~zA
set /a gpuSizeMB=!gpuSize! / 1024 / 1024
echo GPU downloaded, size: !gpuSizeMB!MB
echo Initiating clearing of existing files in .\llama\...
for %%F in (.\libraries\llama_cpp\cpu\*) do if "%%~nF" neq "placeholder" del /F /Q "%%F"
for %%F in (.\libraries\llama_cpp\gpu\*) do if "%%~nF" neq "placeholder" del /F /Q "%%F"
echo Extracting CPU + GPU files to .\llama...
.\libraries\ps_core\pwsh -Command "Expand-Archive -Path .\cache\cpu.zip -DestinationPath .\libraries\llama_cpp\cpu -Force"
.\libraries\ps_core\pwsh -Command "Expand-Archive -Path .\cache\gpu.zip -DestinationPath .\libraries\llama_cpp\gpu -Force"
echo Extraction of GPU + CPU files complete.
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++

:: Download Libre OHM
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo              Download + Extract Libre OHM
echo -------------------------------------------------------
echo Checking for Libre Open Hardware Monitor...
if not exist ".\libraries\libre_ohm\HardwareMonitorLib.dll" (
    echo Downloading Libre Open Hardware Monitor...
    .\libraries\ps_core\pwsh -Command "Invoke-WebRequest -Uri 'https://github.com/LibreHardwareMonitor/LibreHardwareMonitor/releases/download/v0.9.2/LibreHardwareMonitor-net472.zip' -OutFile '.\cache\LibreHardwareMonitor.zip'"
    echo Extracting Libre Open Hardware Monitor...
    .\libraries\ps_core\pwsh -Command "Add-Type -Assembly 'System.IO.Compression.FileSystem'; [System.IO.Compression.ZipFile]::ExtractToDirectory('.\cache\LibreHardwareMonitor.zip', '.\cache\temp'); Move-Item -Path '.\cache\temp\LibreHardwareMonitorLib.dll' -Destination '.\libraries\libre_ohm' -Force"
    echo Libre Open Hardware Monitor installed.
) else (
    echo Libre Open Hardware Monitor already installed.
)
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++

:: Update Graphics
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo                    Gpu Data Refresh
echo -------------------------------------------------------
if exist ".\data\dxdiag.txt" (
    echo Deleting old DxDiag data...
    del /Q ".\data\dxdiag.txt"
    
)
echo Producing DxDiag data...
dxdiag /t ".\data\dxdiag.txt"
echo New DxDiag data generated.
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++

:: Finalizing
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo                       Cleaning Up
echo -------------------------------------------------------
pushd .\cache
for %%F in (*) do if not "%%F"=="placeholder" del /F /Q "%%F"
for /D %%D in (*) do rmdir /S /Q "%%D"
echo Cache folder emptied of contents.
popd
endlocal
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++
goto Exit


:Exit
:: Exit the script
echo.
echo Exiting Setup...
echo.
timeout /t 3 /nobreak >nul
echo.
pause
exit