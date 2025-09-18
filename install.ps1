$REPOSITORY_URL = "https://github.com/jeangiraldoo/dotfiles/"
$BRANCH_NAME = "windows"

$PACKAGES_FILE_NAME = "packages.json"

$DOTFILES_PATH = "$USERPROFILE/.config"

Write-Host "Initializing Windows environment setup" -ForegroundColor Magenta

Write-Host "`nFetching $PACKAGES_FILE_NAME..." -ForegroundColor Cyan
curl.exe -O "https://raw.githubusercontent.com/jeangiraldoo/dotfiles/$BRANCH_NAME/$PACKAGES_FILE_NAME"

Write-Host "`nInstalling packages with Winget..." -ForegroundColor Cyan
winget import -i $PACKAGES_FILE_NAME

Write-Host "`nCloning dotfiles at $DOTFILES_PATH" -ForegroundColor Cyan
git clone "https://github.com/jeangiraldoo/dotfiles" -b $BRANCH_NAME $DOTFILES_PATH

Write-Host "`nFinished setup" -ForegroundColor Magenta
