vim.g.mapleader = " "

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

vim.diagnostic.config({
	float = {
		scope = "line",
		header = "診断メッセージ",
	},
	signs = false,
	severity_sort = true,
})

function _G.build_statusline()
	local RESET_HL = "%#StatusLine#" -- Used to reset/close any active highlights

	local git_section = "%#statusline_section#█%#statusline_git_icon# "
		.. "%#statusline_section_text#"
		.. (vim.b.gitsigns_head or "[No Branch]")
		.. "%#statusline_section#█"

	local file_section = RESET_HL .. "%f" .. (vim.bo.modified and " %#WhiteText#●" or "")

	local diagnostics_section = "%#DiagnosticWarn#☢" .. RESET_HL .. " " .. #vim.diagnostic.get(0)

	local position_section = "%#statusline_section#"
		.. "%#statusline_section_text#󰆌  %l:%c "
		.. "%#statusline_section█"

	return table.concat({
		git_section,
		file_section,
		"%=",
		diagnostics_section,
		position_section,
	}, " ")
end

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.scroll = 10
vim.opt.mouse = ""
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.statusline = "%!v:lua.build_statusline()"
vim.opt.scrolloff = 10
vim.opt.showmode = false
vim.opt.winborder = "rounded"
vim.opt.pumborder = "rounded"
vim.opt.autocomplete = true
vim.opt.completeopt = "menuone,noselect,popup,preview,fuzzy"
vim.opt.complete = "." -- Only scans the current buffer
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.exrc = true

require("utils").editor.set_highlights({
	PMenuMatch = {
		fg = "#ffffff",
	},
	PMenuMatchSel = {
		fg = "#ffffff",
	},
	YankLine = {
		bg = "#d79921",
		fg = "#FFFFFF",
	},
	DiagnosticUnderlineError = {
		underline = true,
		fg = "#ff5555",
	},
	DiagnosticWarn = {
		bg = "orange",
	},
	statusline_section_text = {
		bg = "#1e2030",
		fg = "#d79921",
	},
	StatusLineGitText = {
		fg = "#d79921",
		bg = "#1e2030",
	},
	statusline_git_icon = {
		fg = "#d79921",
		bg = "#b84500",
	},
	statusline_section = {
		bg = "#d79921",
	},
})

vim.cmd([[cnoreabbrev %% %:h]])
require("keymaps")
require("autocmds")
require("plugins")
