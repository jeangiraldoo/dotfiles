#!/bin/bash

declare -A packages
packages[git]="latest"
packages[gh]="latest"
packages[zoxide]="latest"
packages[lazygit]="latest"
packages[yazi]="latest"
packages[eza]="latest"
packages[fish]="latest"
packages[starship]="latest"

declare -A HIGHLIGHTS
HIGHLIGHTS[EXECUTION]="\033[35m" # Magenta
HIGHLIGHTS[STATUS]="\033[34m" # Cyan
HIGHLIGHTS[INFO]="\033[33m" # Yellow
HIGHLIGHTS[RESET]="\033[0m"

display_special_message() {
	echo -e "${HIGHLIGHTS[$2]}${1}${HIGHLIGHTS[RESET]}"
}

display_special_message "Initializing setup...\n" EXECUTION

declare -A MAIN_PKG_MANAGER_CMDS
MAIN_PKG_MANAGER_CMDS[INSTALL]="sudo apt"
MAIN_PKG_MANAGER_CMDS[UPDATE]="sudo apt update"

declare -A SECONDARY_PKG_MANAGER_CMDS
SECONDARY_PKG_MANAGER_CMDS[INSTALL]="brew"
SECONDARY_PKG_MANAGER_CMDS[UPDATE]="brew update"

# [Installing package managers]
display_special_message "\nInstalling secondary package managers...\n" STATUS
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# [Installing packages]
display_special_message "Installing packages..." EXECUTION

update_cmd="${MAIN_PKG_MANAGER_CMDS[UPDATE]}"
$update_cmd

for app_name in "${!packages[@]}"; do
	display_special_message "\nInstalling $app_name" STATUS

	ins_cmd="${MAIN_PKG_MANAGER_CMDS[INSTALL]} install $app_name"
	if ! eval "$ins_cmd"; then
		display_special_message "Installation failed with main package manager. Retrying with fallback..." INFO
		fallback="${SECONDARY_PKG_MANAGER_CMDS[INSTALL]} install $app_name"
		$fallback
	fi
done

# [Install editor]
display_special_message "Installing editor..." EXECUTION

sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt install neovim

# [Cloning dotfiles]
DOTFILES_PATH="$HOME/.config"

display_special_message "\nCloning dotfiles..." STATUS

if [ ! -d "$DOTFILES_PATH" ] || [ -z "$(ls -A "$DOTFILES_PATH" 2>/dev/null)" ]; then
    echo "Cloning dotfiles into $DOTFILES_PATH..."
	git clone https://github.com/jeangiraldoo/dotfiles $DOTFILES_PATH
else
	echo "Dotfiles already exist at $DOTFILES_PATH"
fi

display_special_message "\nSetup finished" EXECUTION
