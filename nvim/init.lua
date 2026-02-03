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

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.scroll = 10
vim.opt.mouse = ""
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.statusline = "%!v:lua.require'ui.statusline'()"
vim.opt.foldenable = true
vim.opt.foldmethod = "manual"
vim.opt.foldcolumn = "1"
vim.opt.scrolloff = 10
vim.opt.showmode = false
vim.opt.winborder = "rounded"
vim.opt.autocomplete = true
vim.opt.completeopt = "menuone,noinsert,popup,preview,fuzzy"
vim.opt.complete = "." -- Only scans the current buffer
vim.opt.pumheight = 12
vim.opt.pumborder = "rounded"
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.cmd([[cnoreabbrev %% %:h]])
require("keymaps")
require("autocmds")
require("plugins")
require("ui")
