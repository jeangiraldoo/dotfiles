vim.g.mapleader = " "

vim.opt.packpath:prepend(vim.fn.stdpath("data") .. "\\site")

require("plugins.init")
require("opts")
require("interface")
require("autocommands")
require("keymaps")
require("lsp")
