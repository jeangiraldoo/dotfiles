# 🌱 Welcome to My Dotfiles! 🌱

I love tinkering with my development environment to make it both productive and enjoyable. Here, you'll find everything about my setup—what I use, why I use it, and how it all fits together. Feel free to take anything you find useful!

The setup is organized into branches:

- **main** — Standard Unix environments (Linux, macOS)
- **termux** — Based on `main`, adapted for Android/Termux
- **windows** — Windows-specific setup

The current branch is `main`. Here you will find settings for:

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
curl -O https://raw.githubusercontent.com/jeangiraldoo/dotfiles/main/install.sh
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

1. It will clone this repository into `~/.config` if `~/.config` does not exist or is empty
