# Windows dotfiles 🪟

I love tinkering with my personal and development environment to make it both productive and fun to use.
Feel free to check my setup, comment on it, or grab anything that you find useful, but be aware that it is tailored to my needs!

> [!NOTE]
> This repository is organized into the following branches:
>
> - **main** — Standard Unix environments (Linux, macOS)
> - **termux** — Based on `main`, adapted for Android/Termux
> - **windows** — Windows-specific setup

## Usage

```powershell
curl.exe -O https://raw.githubusercontent.com/jeangiraldoo/dotfiles/windows/install.ps1
./install.ps1
```

The script does the following:

> [!Note]
>
> The script will choose a "main" package manager to use and a fallback by checking if specific package managers are available.
> Supported package managers in order of preference are: pkg, apt, dnf, pacman, zypper, brew

1. Install all the packages I use in my system
2. It will clone this repository into `~/.config` if `~/.config` does not exist or is empty
