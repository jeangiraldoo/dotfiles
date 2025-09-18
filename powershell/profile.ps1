# Environment variables
$env:EDITOR = "nvim"
$env:STARSHIP_CONFIG = "$HOME/.config/starship.toml"
$env:YAZI_CONFIG_HOME = "$HOME/.config/yazi"
$env:GIT_CONFIG_GLOBAL = "$HOME/.config/git/config"

# Aliases
Set-Alias e $env:EDITOR
function G { lazygit @args }
if (Get-Command eza -ErrorAction SilentlyContinue) {
    # Remove the built-in ls alias (only for this session)
    Remove-Item Alias:ls -ErrorAction SilentlyContinue

    function ls {
        eza --icons=always -a --group-directories-first @args
    }
}

# Vi mode
Set-PSReadLineOption -EditMode vi

# Initializations
Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })
