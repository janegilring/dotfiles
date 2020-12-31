#region UX config

$hasOhMyPosh = Import-Module oh-my-posh -MinimumVersion 3.0 -PassThru -ErrorAction SilentlyContinue
if ($hasOhMyPosh) {
    $themePath = '~/.config/powershell/PoshThemes/jan.json'
    if (Test-Path $themePath) {
        Set-PoshPrompt -Theme $themePath
    } else {
        Set-PoshPrompt -Theme material
    }
}

if (Get-Module PSReadLine) {
    Set-PSReadLineKeyHandler -Chord Alt+Enter -Function AddLine
    Set-PSReadLineOption -ContinuationPrompt "  " -PredictionSource History -Colors @{
        Operator = "`e[95m"
        Parameter = "`e[95m"
        InlinePrediction = "`e[36;7;238m"
    }

    # Searching for commands with up/down arrow is really handy.  The
    # option "moves to end" is useful if you want the cursor at the end
    # of the line while cycling through history like it does w/o searching,
    # without that option, the cursor will remain at the position it was
    # when you used up arrow, which can be useful if you forget the exact
    # string you started the search on.
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
}

#endregion


#region Argument completers

# UnixCompleters
Import-Module Microsoft.PowerShell.UnixCompleters -ErrorAction SilentlyContinue

#endregion