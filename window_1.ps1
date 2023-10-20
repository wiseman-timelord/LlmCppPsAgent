# window_1.ps1

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
$global:llamaCppPath = $null
$global:FreeVRAM = 0
$global:window_identity = "win_1"

# Check administrative + working dir
Check-AdminAndDir

# Display Code
Set-WindowTitleAndSize
DisplayWindow1Header -configPath1 $config_1Path

# Startup Sequence
$keyMappings = @{
    '1' = $config_1Keys
    # Additional mappings can be added here if needed
}
Initialize-Windows -configPath $config_1Path -configType '1'
$env = Load-EnvVariables -envPath $envPath -requiredKeys @("human_name", "local_zone", "model_role", "model_name", "threads_cpu", "threads_gpu")
foreach ($key in $keyMappings['1']) {
    if ($env.ContainsKey($key)) {
        Manage-Config -operation 'update' -filePath $config_XPath -key $key -value $env[$key]
    }
}
$config_1 = Manage-Config -operation 'load' -filePath $config_1Path
$threadValue = $config_1["threads"]
$config_2 = Manage-Config -operation 'load' -filePath $config_2Path
$prompts = Get-Content ".\prompts\converse.txt" -Raw
Initialize-Model  

# Main Loop for window_1
try {  
    Write-Host $global:contentMaps["win_1"]["Listening"] -ForegroundColor $global:colorMaps[$global:window_identity]["DefaultText"]
    $firstWait = $true
    while ($true) {
        $receivedMessage = Manage-Pipe -operation 'receive' -pipeName 'MyPipe'
        
        if (-not $receivedMessage) {
            if ($firstWait) {
                Write-Host "Waiting for response..."
                $firstWait = $false
            }
            continue
        }

        $firstWait = $true
        Write-Host "Received message: $receivedMessage"
		if ($receivedMessage -eq "raw_input_updated") {
            Write-Host "Confirmation: Prompt filled from keys."
            $config_2 = Manage-Config -operation 'load' -filePath $config_2Path
            $receivedMessage = $config_2["raw_input"]
            $systemPart = ($prompts -split "SYSTEM=")[1] -split "INSTRUCTION=" | Select-Object -First 1
            $instructionPart = ($prompts -split "INSTRUCTION=")[1]
            $systemPrompt = ($systemPart -replace "\{human_name\}", $env["human_name"] -replace "\{local_zone\}", $env["local_zone"] -replace "\{model_name\}", $env["model_name"] -replace "\{model_role\}", $env["model_role"]).Trim()
            $instructionPrompt = ($instructionPart -replace "\{human_name\}", $env["human_name"] -replace "\{local_zone\}", $env["local_zone"] -replace "\{model_name\}", $env["model_name"] -replace "\{raw_input\}", $receivedMessage).Trim()
            $finalPrompt = "[INST] <<SYS>> $systemPrompt <</SYS>> $instructionPrompt [/INST]"
            Manage-Config -operation 'update' -filePath $config_1Path -key "next_input" -value $finalPrompt
            Write-Host "Confirmation: Prompt inserted into syntax."
            if ($null -eq $llamaCppPath) {
                Write-Host "llamaCppPath is null. Exiting."
                exit
            }
            $mainExePath = Join-Path $llamaCppPath "main.exe"
            Write-Host "Sending command: $mainExePath -t $calculatedThreads -m $selectedModel -c $contextLength --temp $temp --repeat-penalty $repeatPenalty -ngl $nglValue -b $sBatch -p '$finalPrompt' --log-disable"

			$output = & $mainExePath -t $threadValue -m $selectedModel --color -c $contextLength --temp $temp --repeat-penalty $repeatPenalty -n $nValue -p '$finalPrompt' --log-disable 2> $null
            Write-Host "Done executing main.exe to get raw_output."
            $rawOutput = "Raw Output: " + $output  
            Manage-Config -operation 'update' -filePath $config_1Path -key "raw_output" -value $rawOutput
            Write-Host "Sending raw_output notification..."
            Manage-Pipe -operation 'send' -pipeName 'MyPipe' -message 'raw_output_processed'
            Write-Host "Raw_output space cleared."
            Manage-Config -operation 'update' -filePath $config_1Path -key "raw_output" -value ""
            Write-Host "Clearing raw_input in config_2..."
            Manage-Config -operation 'update' -filePath $config_2Path -key "raw_input" -value ""
            Write-Host "Done clearing raw_input in config_2."
            Manage-Pipe -operation 'send' -pipeName 'MyPipe' -message 'raw_output_updated'
            Write-Host "Confirmation: Message sent through Named Pipe."
            Write-Host "Confirmation: Processed input saved to key."
			Fancy-Delay
			Print-Header
        }
    }
} catch {
    Write-Host "An error occurred: $_"  -ForegroundColor $global:colorMaps[$global:window_identity]["BadMessage"]
}