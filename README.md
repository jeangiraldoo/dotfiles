# Windows dotfiles 🪟

I love tinkering with my personal and development environment to make it both productive and fun to use.
Feel free to check my setup, comment on it, or grab anything that you find useful, but be aware that it is tailored to my needs!

> [!NOTE]
> This repository is organized into the following branches:
>
> - **main** — Standard Unix environments (Linux, macOS)
> - **termux** — Based on `main`, adapted for Android/Termux
> - **windows** — Windows-specific setup

In this branch you will find settings for:

- Neovim (main editor)
- Yazi (file manager)
- Wezterm (terminal emulator)
- Fish (main shell)
- Git (duh)
- Github CLI (gh)
- Lazygit (I prefer it over regular git for day-to-day tasks)
- Starship (favorite cross-shell prompt)

## Usage

```powershell
curl.exe -O https://raw.githubusercontent.com/jeangiraldoo/dotfiles/windows/install.ps1
./install.ps1
```
The script does the following:

1. Install the applications/packages present in `packages.json` using Winget
2. It will clone this repository into `~/.config` if `~/.config` does not exist or is empty
