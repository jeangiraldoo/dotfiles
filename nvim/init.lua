vim.g.mapleader = " "

vim.opt.packpath:prepend(vim.fn.stdpath("data") .. "\\site")

require("opts")
require("highlights")
require("autocommands")
require("plugins.init")
require("keymaps")

vim.cmd("colorscheme tokyonight")

vim.lsp.enable({
	"lua_ls",
	"rust_analyzer",
	"basedpyright",
	"harper_ls",
	"marksman",
	"tinymist",
	"yaml_ls",
})

vim.lsp.set_log_level(vim.log.levels.OFF)
vim.lsp.log.set_format_func(vim.inspect)

vim.diagnostic.config({
	virtual_text = true,
})
