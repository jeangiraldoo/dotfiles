vim.g.mapleader = " "

vim.opt.packpath:prepend(vim.fn.stdpath("data") .. "\\site")

require("plugins.init")
require("opts")
require("highlights")
require("autocommands")
require("keymaps")
require("lsp")

vim.diagnostic.config({
	virtual_text = true,
})
