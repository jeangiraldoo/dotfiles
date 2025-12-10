local utils = require("utils")

utils.editor.set_highlights({
	WhiteText = {
		bg = "#ffffff",
	},
	StatusLineGitIcon = {
		bg = "#b84500",
		fg = "#d79921",
	},
	StatusLineGitText = {
		fg = "#d79921",
		bg = "#1e2030",
	},
	StatusLineGitContainer = {
		bg = "#d79921",
	},
	StatusLinePositionText = {
		bg = "#1e2030",
		fg = "#d79921",
	},
	StatusLineLocationContainer = {
		bg = "#d79921",
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
