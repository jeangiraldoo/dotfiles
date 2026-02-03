vim.g.mapleader = " "
vim.o.exrc = true -- Load project-specific config using `.nvim.lua`

vim.cmd("colorscheme retrobox")

vim.lsp.log.set_level("off")
vim.lsp.log.set_format_func(vim.inspect)
vim.lsp.enable({
	"lua_ls",
	"rust_analyzer",
	"basedpyright",
	"harper_ls",
	"marksman",
	"tinymist",
	"yaml_ls",
})

require("opts")
require("keymaps")
require("autocmds")
require("plugins")
require("ui")
