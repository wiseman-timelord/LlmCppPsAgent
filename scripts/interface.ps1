# interface.ps1

$global:contentMaps = @{
    "win_1" = @{
        "Listening"          = "Listening for pipeline notifications...";
        "Received"           = "Received message: ";
        "PromptFilled"       = "Confirmation: Prompt filled from keys.";
        "PromptInserted"     = "Confirmation: Prompt inserted into syntax.";
        "ConfirmationSent"   = "Confirmation: Message sent through Named Pipe.";
        "ProcessedInput"     = "Confirmation: Processed input saved to key.";
        "Error"              = "An error occurred: "
    };
    "win_2" = @{
        "InterfaceStarted"   = "Interface started - ";
        "ChattingWithModel"  = "Chatting with ";
        "WaitingForResponse" = "Waiting for response..."
    }
}

$global:colorMaps = @{
    "win_1" = @{
        "DefaultText"    = "Yellow";
        "SeparatorColor" = "Blue";
        "HeaderColor"    = "Cyan";
        "BadMessage"     = "Red"
    };
    "win_2" = @{
        "SeparatorColor" = "Blue";
        "HeaderColor"    = "Cyan";
        "BodyColor"      = "Yellow";
		"BadMessage"     = "Red"
    }
}

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

# Resize Window and Set Title
function Set-WindowTitleAndSize {
    param (
        [string]$title = "Default Window Title",
        [int]$width = 88,
        [int]$height = 33,
        [int]$bufferWidth = 88,
        [int]$bufferHeight = 99
    )
    $host.ui.RawUI.WindowTitle = $title
    $host.UI.RawUI.WindowSize = New-Object Management.Automation.Host.Size ($width, $height)
    $host.UI.RawUI.BufferSize = New-Object Management.Automation.Host.Size ($bufferWidth, $bufferHeight)
}

# Calculation for centralized title
function Get-CentralizedTitle {
    param (
        [string]$modelName,
        [string]$localZone
    )

    $width = $host.UI.RawUI.WindowSize.Width
    $text = "Chatting with $modelName in the $localZone"
    $paddingString = " " * [math]::Floor((($width - $text.Length) / 2)-1)

    return "$paddingString$text"
}

# Display Header 
function Display-Header {
    param (
        [string]$headerContent
    )
    
    $width = $host.UI.RawUI.WindowSize.Width
    $separator = "=" * $width
    Write-Host $separator -ForegroundColor $global:colorMaps[$global:window_identity]["SeparatorColor"]
    Write-Host $headerContent -ForegroundColor $global:colorMaps[$global:window_identity]["HeaderColor"]
    Write-Host $separator -ForegroundColor $global:colorMaps[$global:window_identity]["SeparatorColor"]
}

function DisplayWindow1Header {
    param (
        [string]$configPath1
    )
    $temps = Get-ConfigValue -configPath $configPath1 -key "model_temp"
    $currentDateTime = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
    $headerContent = "$temps - Engine started - $currentDateTime"
    Display-Header -headerContent $headerContent
    Display-BodyContentDynamic -contentTitle "Engine Processes:" -contentTheme "" -noBottomLine
}

# Display Body Content Dynamic
function Display-BodyContentDynamic {
    param (
        [string]$contentTitle,
        [string]$contentTheme,
        [switch]$noBottomLine = $false
    )
    $width = $host.UI.RawUI.WindowSize.Width
    $separator1 = "-" * $width
    $separator2 = "+" * $width
    Write-Host $separator2 -ForegroundColor $global:colorMaps[$global:window_identity]["SeparatorColor"]
    Write-Host $contentTitle -ForegroundColor $global:colorMaps[$global:window_identity]["HeaderColor"]
    Write-Host $separator1 -ForegroundColor $global:colorMaps[$global:window_identity]["SeparatorColor"]
    
    # Check if BodyColor is set and not null, else default to Yellow
    $bodyColor = if ($global:colorMaps[$global:window_identity]["BodyColor"]) {
        $global:colorMaps[$global:window_identity]["BodyColor"]
    } else {
        "Yellow"
    }
    
    Write-Host $contentTheme -ForegroundColor $bodyColor
    if (-not $noBottomLine) {
        Write-Host $separator2 -ForegroundColor $global:colorMaps[$global:window_identity]["SeparatorColor"]
    }
}


# Display Window2 Interface
function DisplayWindow2Interface {
    param (
        [string]$configPathX,
        [string]$configPath2
    )
    $width = $host.UI.RawUI.WindowSize.Width
    $separator = "+" * $width
    Write-Host $separator
    $progressWidth = $width - ($Message.Length + 12)
    $step = $Duration / $progressWidth
    Write-Host -NoNewline "$Message ["
    for ($i = 0; $i -lt $progressWidth; $i++) {
        Start-Sleep -Milliseconds $step
        Write-Host -NoNewline "="
    }
    Write-Host "] Complete."
    Start-Sleep -Seconds 2
}

# Display Window2 Interface
function DisplayWindow2Interface {
    param (
        [string]$configPathX,
        [string]$configPath2
    )
    $modelName = Get-ConfigValue -configPath $configPathX -key "model_name"
    $localZone = Get-ConfigValue -configPath $configPathX -key "local_zone"
    $humanName = Get-ConfigValue -configPath $configPath2 -key "human_name"
    $serverName = Get-ConfigValue -configPath $configPath2 -key "server_name"
    $headerContent = "$modelName - $localZone - $humanName @ $serverName"
    Display-Header -headerContent $headerContent
    Display-BodyContentDynamic -contentTitle "System Status:" -contentTheme "Running optimally"
}

