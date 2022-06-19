$configPath = "~/.config"

if (Test-Path $configPath) {
    "Config path $configPath exists" >> ~\dotfiles.log

} else {
    "Config path $configPath does not exist - creating" >> ~\dotfiles.log

    New-Item -Path ~/.config -ItemType Directory

}

# Set up symlinks
$customConfigPath = (Join-Path $PSScriptRoot '.config')
Get-ChildItem -Path $customConfigPath | ForEach-Object {
    New-Item -Path (Join-Path '~/.config' $_.Name) -ItemType SymbolicLink -Value $_.FullName
}


Install-Module PSDepend -Force

#Disabled for testing
#Invoke-PSDepend -Force (Join-Path $PSScriptRoot 'requirements.psd1')

"install.ps1 completed $(Get-Date)" >> ~\dotfiles.log