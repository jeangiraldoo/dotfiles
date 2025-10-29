vim.g.mapleader = " "
vim.o.exrc = true -- Load project-specific config using `.nvim.lua`

require("opts")
require("keymaps")
require("lsp")
require("autocmds")
require("plugins")
require("ui")
