# Termux dotfiles 📱

I love tinkering with my personal and development environment to make it both productive and fun to use.
Feel free to check my setup, comment on it, or grab anything that you find useful, but be aware that it is tailored to my needs!

> [!NOTE]
> This repository is organized into the following branches:
>
> - **main** — Standard Unix environments (Linux, macOS)
> - **termux** — Based on `main`, adapted for Android/Termux
> - **windows** — Windows-specific setup

In this branch you will find settings for:

- Termux (Terminal emulator & Linux environment for Android)
- Neovim (main editor)
- Yazi (file manager)
- Wezterm (terminal emulator)
- Fish (main shell)
- Git (duh)
- Github CLI (gh)
- Lazygit (I prefer it over regular git for day-to-day tasks)
- Starship (favorite cross-shell prompt)

## Usage

```bash
curl -O https://raw.githubusercontent.com/jeangiraldoo/dotfiles/termux/install.sh
chmod +x install.sh
./install.sh
```
The script does the following:

> [!Note]
>
> The script will choose a "main" package manager to use and a fallback by checking if specific package managers are available.
> Supported package managers in order of preference are: pkg, apt, dnf, pacman, zypper, brew

1. Install the following applications/packages:

- Yazi
- Fish
- Git
- Github CLI (gh)
- Lazygit
- Starship
- Zoxide
- Eza

2. It will clone this repository into `~/.config` if `~/.config` does not exist or is empty
