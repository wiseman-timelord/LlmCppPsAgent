# window_2.ps1

# Imports
. ".\scripts\utility.ps1"
. ".\scripts\model.ps1"
. ".\scripts\configuration.ps1"
. ".\scripts\interface.ps1"

# Paths
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$config_1Path = ".\data\config_1.psd1"
$config_2Path = ".\data\config_2.psd1"
$config_XPath = ".\data\config_X.psd1"
$envPath = ".\.ENV"

# Variables
$waitingForResponse = $false
$global:window_identity = "win_2"

# Check administrative + working dir
Check-AdminAndDir

# Resize Window and Set Title
Set-WindowTitleAndSize -title "LlmCppPsBot - Window 2 (Interface)" -width 88 -height 33 -bufferWidth 88 -bufferHeight 99

# Display Header for Window 2
Display-Header -headerContent "Interface started - $(Get-Date -Format "HH:mm yyyy/MM/dd")"

# Initialization (window_2)
Initialize-Windows -configPath $config_2Path -configType '2'
Start-Sleep -Seconds 3

# Load .ENV
$requiredKeys = @("human_name", "model_name", "local_zone")
$env = Load-EnvVariables -envPath $envPath -requiredKeys $requiredKeys
foreach ($key in $requiredKeys) {
    Manage-Config -operation 'update' -filePath $config_2Path -key $key -value $env[$key]
}

# Main Loop for window_2
while ($true) {
    Clear-Host  
    $config_1 = Manage-Config -operation 'load' -filePath $config_1Path
    $config_2 = Manage-Config -operation 'load' -filePath $config_2Path
    Display-Header -headerContent (Get-CentralizedTitle -modelName $env['model_name'] -localZone $env['local_zone'])
    Display-BodyContentDynamic -contentTitle "$($env['human_name'])'s Input:" -contentTheme $config_2["raw_input"]
    if ($waitingForResponse -and $config_1["raw_output"] -ne "") {
        $parsed_output = Parse-Response -rawResponse $config_1["raw_output"]
        Manage-Config -operation 'update' -filePath $config_2Path -key "parsed_output" -value $parsed_output
        $waitingForResponse = $false
    }
    Display-BodyContentDynamic -contentTitle "$($env['model_name'])'s Output:" -contentTheme $config_2["parsed_output"]
    Display-BodyContentDynamic -contentTitle "Your Next Input:" -contentTheme "" -noBottomLine
    if (-not $waitingForResponse) {
        $userInput = Read-Host
        if ($userInput) {
            Manage-Config -operation 'update' -filePath $config_2Path -key "raw_input" -value $userInput
            Manage-Pipe -operation 'send' -pipeName 'MyPipe' -message 'raw_input_updated'
        $waitingForResponse = $true
        }
    } else {
        Write-Host "Waiting for response..."
        Start-Sleep -Seconds 2
    }
}
