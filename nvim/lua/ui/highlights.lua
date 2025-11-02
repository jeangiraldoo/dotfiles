local HIGHLIGHTS = {
	WhiteText = {
		fg = "#ffffff",
	},
	StatusLineGitIcon = {
		fg = "#b84500",
		bg = "#82aaff",
	},
	StatusLineGitText = {
		bg = "#82aaff",
		fg = "#1e2030",
	},
	StatusLineGitAdded = {
		bg = "#82aaff",
		fg = "#009200",
	},
	StatusLineGitChanged = {
		bg = "#82aaff",
		fg = "#0000b5",
	},
	StatusLineGitRemoved = {
		bg = "#82aaff",
		fg = "#a20000",
	},
	StatusLineGitContainer = {
		fg = "#82aaff",
	},
	StatusLinePositionText = {
		fg = "#1e2030",
		bg = "#82aaff",
	},
	StatusLineLocationContainer = {
		fg = "#82aaff",
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
}

for highlight_name, data in pairs(HIGHLIGHTS) do
	vim.api.nvim_set_hl(0, highlight_name, data)
end
