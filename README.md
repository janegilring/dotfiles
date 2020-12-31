# Jan Egil Ring's dotfiles

The installation will:

1. Use `install.sh` as the entry point for Codespaces which will install PowerShell and run `install.ps1`
2. The `install.ps1` will setup all the symbolic links and install and invoke [PSDepend](https://github.com/RamblingCookieMonster/PSDepend)
3. PSDepend will install the dependencies listed in the [requirements.psd1](./requirements.psd1)

## PowerShell Profiles

Since the `CurrentUser` profiles are stored in `~/.config/powershell`,
the install script symlinks this directory and the profiles are picked up automatically when you launch PowerShell.

This repository used Tyler Leonhardt`s [dotfiles repository](https://github.com/TylerLeonhardt/dotfiles) as a starting point.