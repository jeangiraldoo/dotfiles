local COLORSCHEME_NAME = "tokyonight-moon"

if not (vim.g.colors_name == COLORSCHEME_NAME) then
	vim.cmd("colorscheme " .. COLORSCHEME_NAME)
end

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
	-- vim-illuminate plugin
	IlluminatedWordRead = {
		bold = true,
		bg = "#39414c",
	},
	IlluminatedWordWrite = {
		bold = true,
		bg = "#4c3f39",
	},
	-- nvim-treesitter-context
	TreesitterContext = {
		bg = "#003767",
		italic = true,
		bold = true,
	},
}

for highlight_name, data in pairs(HIGHLIGHTS) do
	vim.api.nvim_set_hl(0, highlight_name, data)
end
