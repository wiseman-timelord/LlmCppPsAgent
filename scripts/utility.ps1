# utility.ps1

# Check administrative + working dir
function Check-AdminAndDir {
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    if ($isAdmin) {
        Write-Host "This script is running with administrative privileges!" -ForegroundColor Green
    } else {
        Write-Host "This script is NOT running with administrative privileges." -ForegroundColor Red
    }
    $currentDir = Get-Location
    Write-Host "Current Working Directory: $currentDir" -ForegroundColor Yellow
    Start-Sleep -Seconds 3
    Clear-Host
}

# Get Graphics Info
function Get-GraphicsInfo {
    $graphicsInfoArray = @()
    $dxdiagPath = ".\data\dxdiag.txt"
    if (-not (Test-Path $dxdiagPath)) {
        Write-Host "dxdiag.txt is missing, run Hw_Setup.bat first!"
        exit
    }
    $dxdiagContent = Get-Content $dxdiagPath
    $memoryLine = $dxdiagContent | Where-Object { $_ -match 'Dedicated Memory: (\d+) MB' }
    $totalGraphicsMemory = [int64]([regex]::Match($memoryLine, 'Dedicated Memory: (\d+) MB').Groups[1].Value)
    $DedicatedUsage1 = [math]::Round((Get-Counter -Counter "\GPU Adapter Memory(*)\Dedicated Usage").CounterSamples[0].CookedValue / 1MB, 0) 
    $global:FreeVRAM = $totalGraphicsMemory - $DedicatedUsage1
    return Get-WmiObject -Query "SELECT * FROM Win32_VideoController" | Select-Object @{N='Name';E={$_.Name}}, @{N='Memory';E={$totalGraphicsMemory}}
}

# Calculate Threads
function Calculate-Threads {
    param (
        [string]$configPath = ".\data\config_1.psd1" 
    )
    $config = Manage-Config -operation 'load' -filePath $configPath
    if ($config['gpu_or_cpu'] -eq "gpu") {
        $threads = $config['threads_gpu']
    } else {
        $threads = $config['threads_cpu']
    }
    $calculatedThreads = [math]::Floor($threads * 0.85)
    Write-Host "Using safe number of $calculatedThreads threads."
    return $calculatedThreads
}

# Get CPU + GPU temps
function GetTemperatures {
    if (-not ([System.Management.Automation.PSTypeName]'LibreHardwareMonitor.Hardware.Computer').Type) {
        Add-Type -Path ".\libraries\libre_ohm\LibreHardwareMonitorLib.dll"
    }
    $computer = New-Object LibreHardwareMonitor.Hardware.Computer
    $computer.IsCpuEnabled = $TRUE
    $computer.IsGpuEnabled = $TRUE
    $computer.Open()
    $cpuTemp, $gpuTemp = $null, $null
    $computer.Hardware | ForEach-Object {
        $_.Sensors | Where-Object { $_.SensorType -eq "Temperature" } | ForEach-Object {
            if ($_.Name -eq "Core (Tctl/Tdie)") { $cpuTemp = "CPU {0}c" -f [math]::Round($_.Value) }
            elseif ($_.Name -eq "GPU Core") { $gpuTemp = "GPU {0}c" -f [math]::Round($_.Value) }
        }
    }
    $computer.Close()
    return "$cpuTemp, $gpuTemp"
}
