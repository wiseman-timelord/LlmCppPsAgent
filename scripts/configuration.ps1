# configuration.ps1

# Dynamic Config Mapping based on the filename
function Get-ConfigType {
    param (
        [Parameter(Mandatory=$true)]
        [string]$filePath
    )
    $configTypes = @{
        '1' = @("next_input", "model_temp", "batch_size", "gpu_or_cpu", "ngl_value", "context_ctx", "model_file", "repeat_stop", "safe_threads", "raw_output")
        '2' = @("raw_input", "parsed_output")
        'X' = @("human_name", "local_zone", "model_role", "model_name")
    }
    switch ($filePath) {
        { $_ -like "*config_1*" } { return $configTypes['1'] }
        { $_ -like "*config_2*" } { return $configTypes['2'] }
        { $_ -like "*config_X*" } { return $configTypes['X'] }
        default { Write-Warning "Unsupported config file."; return $null }
    }
}

# Manage configs
function Manage-Config {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet('load','save','update')]
        [string]$operation,  
        [Parameter(Mandatory=$true)]
        [string]$filePath,
        [Parameter(Mandatory=$false)]
        [string]$key,
        [Parameter(Mandatory=$false)]
        [string]$value
    )
    if (-not (Test-Path $filePath)) {
        Write-Warning "File $filePath not found."
        return $null
    }
    $config = @{}
    if ($operation -ne 'save') {
        $config = Import-PowerShellDataFile -Path $filePath -ErrorAction SilentlyContinue
        if (-not $config) {
            Write-Warning "Error importing the PowerShell data file."
            return $null
        }
    }
    $allowedKeys = Get-ConfigType -filePath $filePath
    switch ($operation) {
        'load' { return $config }
        'save' {
            if ($allowedKeys -contains $key) {
                $config[$key] = $value
                $content = "@{`n" + (($allowedKeys | ForEach-Object { "    $_ = '$($config[$_])'" }) -join "`n") + "`n}"
                $content | Out-File -FilePath $filePath
            } else {
                Write-Warning "Error: Key $key is not allowed for this config."
            }
        }
        'update' {
            if ($config.ContainsKey($key) -and $allowedKeys -contains $key) {
                $config[$key] = $value
                $content = "@{`n" + (($allowedKeys | ForEach-Object { "    $_ = '$($config[$_])'" }) -join "`n") + "`n}"
                $content | Out-File -FilePath $filePath
            } else {
                Write-Warning "Error: Key '$key' not found in config or it's not allowed. Cannot update."
            }
        }
    }
}


# Clear garbage in config files
function Clear-ConfigKeys {
    param (
        [string]$configPath
    )
    $keysToClear = Get-ConfigType -filePath $configPath
    foreach ($key in $keysToClear) {
        Manage-Config -operation 'update' -filePath $configPath -key $key -value ""
    }
}

# Initialize Windows
function Initialize-Windows {
    param (
        [string]$configPath
    )
    Clear-ConfigKeys -configPath $configPath
}

# Manage pipes
function Manage-Pipe {
    param (
        [string]$operation,  
        [string]$pipeName,
        [string]$message
    )
    try {
    } catch {
        Write-Warning "An error occurred while managing the pipe: $_"
    }
}

# Load Environment Variables
function Load-EnvVariables {
    param (
        [string]$envPath,
        [string[]]$requiredKeys
    )
    $env = @{}
    if (-not (Test-Path $envPath)) {
        Write-Error "Environment file $envPath not found."
        throw "FileNotFound"
    }
    Get-Content $envPath | Where-Object { $_ -notmatch "^\#" } | ForEach-Object {
        $keyValue = ($_ -split "#", 2 | Select-Object -First 1) -split "\s*=\s*", 2
        if ($keyValue.Count -eq 2 -and $requiredKeys -contains $keyValue[0].Trim()) {
            $env[$keyValue[0].Trim()] = $keyValue[1].Trim()
        }
    }
    return $env
}

# This function gets the config value for a given key
function Get-ConfigValue {
    param (
        [string]$configPath,
        [string]$key
    )
    return (Manage-Config -operation 'load' -filePath $configPath)[$key]
}
