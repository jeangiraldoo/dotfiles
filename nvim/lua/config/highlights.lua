local HIGHLIGHTS = {
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
