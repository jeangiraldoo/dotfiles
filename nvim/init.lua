vim.g.mapleader = " "

vim.opt.packpath:prepend(vim.fn.stdpath("data") .. "\\site")

require("autocommands")
require("keymaps")
require("lsp")
require("plugins.init")
require("interface")
