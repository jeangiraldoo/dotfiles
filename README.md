# Welcome to My Dotfiles!

I love tinkering with my development environment to make it both productive and enjoyable. Here, you'll find everything about my setup—what I use, why I use it, and how it all fits together. Feel free to take anything you find useful!

## Code Editor

I currently use both **Neovim** and **IntelliJ IDEA**—the latter specifically for Java-related development. Since I keep IntelliJ vanilla, I'll focus on my **Neovim** setup:

Check out my [Neovim config file](./nvim/init.lua).

### Plugins

- [**Codedocs**][codedocs]: My very own plugin! It helps me automatically document my code across multiple languages in a simple way.
- [**Markview**](https://github.com/OXY2DEV/markview.nvim): Lets me preview my Markdown files _without leaving my editor_. Since I write a lot of Markdown, this plugin is a must-have. Also, the way it renders Markdown is just pretty.
- [**Conform**](https://github.com/stevearc/conform.nvim): Formats my files automatically on save. There are tons of plugins like this one out there, but this one was by far the easiest to set up.
- [**nvim-treesitter**](https://github.com/nvim-treesitter/nvim-treesitter): Helps me manage Treesitter parsers effortlessly.
- [**Autopairs**](https://github.com/windwp/nvim-autopairs): A bit controversial, but I prefer my editor to handle opening/closing characters for me.
- [**Typr**](https://github.com/nvzone/typr): I like to start coding sessions by warming up. This plugin is great for touch-typing practice—I’m currently at **77 WPM**, hoping to improve!

---

## Terminal Emulator

My terminal of choice is [WezTerm](https://wezterm.org/) because it’s fully **cross-platform**. Since I currently use Windows (but plan to move to Linux), having a consistent terminal experience is really important to me.

Another thing I love is that **WezTerm is configurable using Lua**, the same language I use for Neovim and my plugin, [Codedocs][codedocs]. This makes it super easy to extend or even write my own plugins.

---

## Tools

I’m always looking for ways to improve my workflow, and these tools help me do just that. Since I love working from the terminal, most of them cater to that preference:

- [**eza**](https://github.com/eza-community/eza): A more powerful alternative to `ls`. It supports **tree views**, **icons**, and **colored output**, which makes browsing directories much nicer.
- [**Git**](https://git-scm.com/): Pretty self-explanatory.
- [**Mermaid**](https://mermaid.js.org/): Helps me write diagrams in plain text. No more dragging boxes around, I can just focus on the structure, and let Mermaid handle the rest. Additionally, it works great with Git since it is plain text!

## Nerd Font

I use [**Monocraft**][mainfont] because I love the **retro Minecraft aesthetic**. Plus, it supports:

- **Ligatures** (for better code readability).
- **Monospacing**.

---

If you have any suggestions, feel free to share them! 🚀

[mainfont]: https://github.com/IdreesInc/Monocraft
[codedocs]: https://github.com/jeangiraldoo/codedocs.nvim
