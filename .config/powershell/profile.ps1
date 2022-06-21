$AvailableModules = Get-Module -ListAvailable | Select-Object -ExpandProperty name
$WorkspaceFolder = Join-Path -Path (Get-ChildItem /workspaces | Select-Object -First 1).FullName -ChildPath .devcontainer/
$WorkspacePowerShellFolder = Join-Path -Path $WorkspaceFolder -ChildPath powershell

if (-not (Test-Path -Path $WorkspacePowerShellFolder)) {
    $null = New-Item -Path $WorkspacePowerShellFolder -ItemType Directory -Force
}

if ($AvailableModules -contains 'Terminal-Icons') {
    Import-Module -Name Terminal-Icons
}

# PSReadLine

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

if ($IsLinux) {

    if ($AvailableModules -contains 'Microsoft.PowerShell.UnixCompleters') {
        Import-Module Microsoft.PowerShell.UnixCompleters
        Import-UnixCompleters -ErrorAction Ignore
    }

    Set-PSReadLineOption -HistorySavePath "$WorkspacePowerShellFolder/PSReadLine_history.txt"

}

Set-PSReadLineOption -MaximumHistoryCount 32767

switch ($PSVersionTable.PSVersion.Major) {
    7 {
        #Set-PSReadLineOption -PredictionSource HistoryAndPlugin #7.2 or a higher version of PowerShell is required
        Set-PSReadLineOption -PredictionSource History
        Set-PSReadLineOption -PredictionViewStyle ListView -WarningAction SilentlyContinue
    }
    default {
        Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward # Must be disabled for Az.Tools.Predictor/ListView to work
        Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
        Set-PSReadLineOption -PredictionViewStyle InlineView
        Set-PSReadLineOption -PredictionSource History
    }
}

function Set-EnvVar {
    if (Test-Path -Path ~/.Azure/AzureRmContext.json) {
        $azureContext = Get-Content ~/.Azure/AzureRmContext.json | ConvertFrom-Json
        $subscriptionName = $azureContext.Contexts.($azureContext.DefaultContextKey).Subscription.Name
        $env:oh_my_azure_context = $subscriptionName
    } else {
        $env:oh_my_azure_context = $null
    }

    $env:oh_my_psversion = ($PSVersionTable.PSVersion.ToString() -split '-')[0]
}
New-Alias -Name 'Set-PoshContext' -Value 'Set-EnvVar' -Scope Global

if (Get-Command -Name 'oh-my-posh' -ErrorAction SilentlyContinue) {

    if (Test-Path -Path "$WorkspacePowerShellFolder/themes/jan.json") {

        oh-my-posh init pwsh --config "$WorkspacePowerShellFolder/themes/jan.json" | Invoke-Expression

    } else {

        oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/jandedobbeleer.omp.json'

    }
}

New-Alias -Name k -Value kubectl -Scope Global

#Enable concise errorview for PS7 and up
if ($psversiontable.psversion.major -ge 7) {
    $ErrorView = 'ConciseView'
}