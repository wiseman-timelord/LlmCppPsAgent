# model.ps1

# Imports
. ".\scripts\utility.ps1"
. ".\scripts\configuration.ps1"

# Initialize the model
function Initialize-Model {
    $global:Config1 = Manage-Config -operation 'load' -filePath '.\data\config_1.psd1'
    $global:Temp = $global:Config1.model_temp
    $global:RepeatPenalty = $global:Config1.repeat_stop
    $global:NglValue = $global:Config1.ngl_value
    $global:SBatch = $global:Config1.batch_size
    $graphicsCards = @()
    Get-GraphicsInfo | ForEach-Object {
        Write-Host "GPU: $($_.Name) - ${global:FreeVRAM}MB."
        $graphicsCards += $global:FreeVRAM
    }
    $selectedModel, $contextLength, $model_process = modelAndLlamaSelection
    $global:LlamaCppPath = ".\libraries\llama_cpp\$model_process"
    $totalCores = Calculate-Threads -threads_cpu $env:threads_cpu -threads_gpu $env:threads_gpu -llamaCppPath $global:LlamaCppPath
    $exePath = "$global:LlamaCppPath\main.exe"
    Write-Host "Main used: $($exePath -replace [regex]::Escape($scriptPath), '')."
    $global:ContextLength = $contextLength
    $global:SelectedModel = $selectedModel
    Manage-Config -operation 'update' -filePath '.\data\config_1.psd1' -key 'next_input' -value $selectedModel
}

# Build and execute the command
function BuildExecute-Command {
    param (
        [string]$exePath,
        [string]$selectedModel,
        [int]$contextLength
    )
    $command = "$exePath -t -m $selectedModel -c $contextLength --temp $global:config_1.model_temp --repeat-penalty $global:config_1.repeat_stop -ngl $global:config_1.ngl_value -b $global:config_1.batch_size --log-disable -p '[INST] <<SYS>> {SYSTEM_PROMPT} <</SYS>> {INSTRUCT_PROMPT} [/INST]'"
    Write-Host "Command to run main.exe: $command"
}

# Parse the response
function Parse-Response {
    param (
        [string]$rawResponse
    )
    $cleanedResponse = $rawResponse.Trim()
    $cleanedResponse = $cleanedResponse -replace '^---\n*', ''
    $cleanedResponse = $cleanedResponse -replace '^### (Solution|Summary|Response|Instruction|Example|Output|Answer|Prompt Answer):\n', ''
    $cleanedResponse = $cleanedResponse -replace "^\.'", ''
    $cleanedResponse = $cleanedResponse -replace '^Please make sure.*\n?', ''
    $cleanedResponse = $cleanedResponse -replace "^(Sure, here's|Sure! Here is|Sure! Here's|Sure! here is).*\n?", ''
    return $cleanedResponse
}

# Select model & update keys.
function modelAndLlamaSelection {
    param (
        [string]$modelsPath
    )

    $models = Get-ChildItem -Path $modelsPath -Include "*.gguf", "*.GGUF" -Recurse
    switch ($models.Count) {
        0 {
            Write-Host "No model files found. Exiting."
            exit
        }
        1 { 
            $selectedModel = $models[0].FullName
        }
        default {
            Write-Host "Multiple models found. Please select one:"
            $models | ForEach-Object -Begin { $counter = 1 } -Process {
                Write-Host "$counter. $($_.BaseName)"
                $counter++
            }
            do {
                $modelNumber = Read-Host "Enter model number"
            } while ($modelNumber -lt 1 -or $modelNumber -gt $models.Count)
            $selectedModel = $models[$modelNumber - 1].FullName
        }
    }
    $contextLengthMapping = @{
        "8k" = 8192
        "16k" = 16384
        "32k" = 32768
        "64k" = 65536
        "128k" = 131072
    }
    $contextLength = $contextLengthMapping.GetEnumerator() | Where-Object { $selectedModel -match $_.Key } | Select-Object -ExpandProperty Value
    if (-not $contextLength) { 
        $contextLength = 4096 
    }
    $modelSize = [math]::Round((Get-Item $selectedModel).Length / 1MB)
    $model_process = if ($global:FreeVRAM -gt $modelSize) { "gpu" } else { "cpu" }
    $config_1.model_file = $selectedModel
    $config_1.context_ctx = $contextLength
    $config_1.gpu_or_cpu = $model_process
    return $selectedModel, $contextLength, $model_process
}
