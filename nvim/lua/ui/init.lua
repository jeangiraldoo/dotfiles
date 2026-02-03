local utils = require("utils")

utils.editor.set_highlights({
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
