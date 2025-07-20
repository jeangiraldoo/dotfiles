vim.g.mapleader = " "

require("config")

local opts = {
	ruler = true,
	number = true,
	relativenumber = true,
	cursorline = true,
	scroll = 10,
	mouse = "",
	tabstop = 4,
	shiftwidth = 4,
	foldenable = true,
	foldmethod = "manual",
	foldcolumn = "1",
	listchars = {
		tab = "» ",
		trail = "·",
		eol = "¬",
		extends = "›",
		precedes = "‹",
		space = "·",
	},
}

vim.lsp.enable({
	"lua_ls",
	"rust_analyzer",
	"ruff",
	"harper_ls",
	"marksman",
	"tinymist",
	"yaml_ls",
})
vim.diagnostic.config({
	virtual_text = true,
})

for name, val in pairs(opts) do
	vim.opt[name] = val
end
