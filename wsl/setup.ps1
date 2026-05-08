$DISTRO_NAME = "ubuntu"
$DISTRO_DOTFILES_PATH = "~/.config"

Write-Host "Initializing WSL setup" -ForegroundColor Magenta

Write-Host "`nInstalling Linux distribution..." -ForegroundColor Cyan
wsl --install -d $DISTRO_NAME

Write-Host "`nSetting up the distribution's dotfiles at $DISTRO_DOTFILES_PATH..." -ForegroundColor Cyan
wsl -d $DISTRO_NAME -- bash -c "git clone https://github.com/jeangiraldoo/dotfiles $DISTRO_DOTFILES_PATH"
