vim.g.mapleader = " "

vim.cmd "colorscheme retrobox"

vim.diagnostic.config {
	float = {
		scope = "line",
		header = "診断メッセージ",
	},
	signs = false,
	severity_sort = true,
}

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.o.mouse = ""
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.statusline = "%!v:lua.build_statusline()"
vim.o.scrolloff = 10
vim.o.showmode = false
vim.o.winborder = "rounded"
vim.o.pumborder = "rounded"
vim.o.autocomplete = true
vim.opt.completeopt = {
	"menuone",
	"noselect",
	"popup",
	"preview",
	"fuzzy",
}
vim.o.complete = "."
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.exrc = true
vim.o.signcolumn = "yes"

vim.cmd [[cnoreabbrev %% %:h]]

require "editing"
require "plugins"
require "lsp"
require "ui"
