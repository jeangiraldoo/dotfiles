local COLORSCHEME = "tokyonight-moon"

vim.g.mapleader = " "
vim.o.exrc = true -- Load project-specific config using `.nvim.lua`

require("opts")
require("keymaps")
require("lsp")
require("autocmds")
require("plugins")

vim.cmd("colorscheme " .. COLORSCHEME)

require("ui")
