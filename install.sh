#!/bin/bash

declare -A HIGHLIGHTS
HIGHLIGHTS[EXECUTION]="\033[35m" # Magenta
HIGHLIGHTS[STATUS]="\033[34m" # Cyan
HIGHLIGHTS[INFO]="\033[33m" # Yellow
HIGHLIGHTS[RESET]="\033[0m"

display_special_message() {
	echo -e "${HIGHLIGHTS[$2]}${1}${HIGHLIGHTS[RESET]}"
}

display_special_message "Initializing setup...\n" EXECUTION

# [Installing packages]
display_special_message "Installing packages..." STATUS

declare -A packages
packages[git]="latest"
packages[gh]="latest"
packages[zoxide]="latest"
packages[lazygit]="latest"
packages[yazi]="latest"
packages[eza]="latest"
packages[fish]="latest"
packages[starship]="latest"

declare -A OS_PKG_MANAGERS

# Each package manager maps to its sudo requirement ("sudo" or "")
OS_PKG_MANAGERS=(
	[pkg]="" # For Termux
    [apt]="sudo"
    [dnf]="sudo"
    [pacman]="sudo"
    [zypper]="sudo"
    [brew]=""
)
PREFERRED_ORDER=(pkg apt dnf pacman zypper brew)

MAIN_PKG_MANAGER_NAME=""
FALLBACK_PKG_MANAGER_NAME=""

# Detect installed package managers in order of preference
for mgr in "${PREFERRED_ORDER[@]}"; do
    if command -v "$mgr" >/dev/null 2>&1; then
        if [ -z "$MAIN_PKG_MANAGER_NAME" ]; then
            MAIN_PKG_MANAGER_NAME="$mgr"
        elif [ -z "$FALLBACK_PKG_MANAGER_NAME" ]; then
            FALLBACK_PKG_MANAGER_NAME="$mgr"
			break
		fi
	fi
done

if [ -z "$MAIN_PKG_MANAGER_NAME" ]; then
	echo "No supported package manager found!"
	exit 1
fi

MAIN_PKG_MANAGER_SUDO="${OS_PKG_MANAGERS[$MAIN_PKG_MANAGER_NAME]}"
FALLBACK_PKG_MANAGER_SUDO="${OS_PKG_MANAGERS[$FALLBACK_PKG_MANAGER_NAME]}"

display_special_message "Detected distro: $NAME
Package managers:
[$MAIN_PKG_MANAGER_SUDO] Main: $MAIN_PKG_MANAGER_NAME
[${FALLBACK_PKG_MANAGER_SUDO}] Fallback: ${FALLBACK_PKG_MANAGER_NAME}" INFO

for app_name in "${!packages[@]}"; do
	echo -e "\nInstalling $app_name"

	cmd=($MAIN_PKG_MANAGER_SUDO $MAIN_PKG_MANAGER_NAME install $app_name)
	if ! "${cmd[@]}"; then
		fallback_cmd=($FALLBACK_PKG_MANAGER_SUDO $FALLBACK_PKG_MANAGER_NAME install $app_name)
		echo "$MAIN_PKG_MANAGER_NAME failed. Attempting installation using $FALLBACK_PKG_MANAGER_NAME"
		"${fallback_cmd[@]}"
	fi
done

# [Cloning dotfiles]
display_special_message "\nCloning dotfiles..." STATUS

DOTFILES_PATH="$HOME/.config"

if [ ! -d "$DOTFILES_PATH" ] || [ -z "$(ls -A "$DOTFILES_PATH" 2>/dev/null)" ]; then
    echo "Cloning dotfiles into $DOTFILES_PATH..."
	git clone https://github.com/jeangiraldoo/dotfiles $DOTFILES_PATH
else
	echo "Dotfiles already exist at $DOTFILES_PATH"
fi

display_special_message "\nSetup finished" EXECUTION
