local utils = require("utils")

utils.editor.set_highlights({
	WhiteText = {
		bg = "#ffffff",
	},
	PMenu = {
		bg = "#222222",
		italic = true,
		fg = "#ffffff",
	},
	PMenuSel = {
		bg = "#690083",
		fg = "#ffffff",
	},
	PMenuMatch = {
		fg = "#ffffff",
	},
	PMenuMatchSel = {
		italic = true,
		fg = "#ffffff",
	},
	YankLine = {
		bg = "#44004c",
		fg = "#FFFFFF",
	},
	DiagnosticUnderlineError = {
		underline = true,
		fg = "#ff5555",
	},
	FloatBorder = {
		fg = "#828100",
	},
})

vim.diagnostic.config({
	float = {
		scope = "line",
		border = "rounded",
		source = "always",
		header = "診断メッセージ",
	},
	signs = false,
	underline = true,
	severity_sort = true,
})
