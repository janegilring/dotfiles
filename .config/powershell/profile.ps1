Import-Module -Name Terminal-Icons

# PSReadLine

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

if ($IsLinux) {
Import-Module Microsoft.PowerShell.UnixCompleters
Import-UnixCompleters
Set-PSReadLineOption -HistorySavePath '/workspaces/PSDemo/.devcontainer/powershell/PSReadLine/Visual Studio Code Host_history.txt'
}

Set-PSReadLineOption -MaximumHistoryCount 32767 #-HistorySavePath "$([environment]::GetFolderPath('ApplicationData'))\Microsoft\Windows\PowerShell\PSReadLine\history.txt"

switch ($PSVersionTable.PSVersion.Major) {
    7 {
        #Set-PSReadLineOption -PredictionSource HistoryAndPlugin #7.2 or a higher version of PowerShell is required
        Set-PSReadLineOption -PredictionSource History
        Set-PSReadLineOption -PredictionViewStyle ListView
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

oh-my-posh init pwsh --config /workspaces/PSDemo/.devcontainer/powershell/themes/jan.json | Invoke-Expression

New-Alias -Name k -Value kubectl -Scope Global

#Enable concise errorview for PS7 and up
if ($psversiontable.psversion.major -ge 7) {
    $ErrorView = 'ConciseView'
}