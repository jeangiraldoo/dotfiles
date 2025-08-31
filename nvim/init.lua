vim.g.mapleader = " "

vim.opt.packpath:prepend(vim.fn.stdpath("data") .. "\\site")

require("opts")
require("autocommands")
require("plugins.init")
require("keymaps")
require("lsp")
require("highlights")

vim.cmd("colorscheme tokyonight")

vim.diagnostic.config({
	virtual_text = true,
})
