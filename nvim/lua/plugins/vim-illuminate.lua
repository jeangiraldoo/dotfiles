local OPTS = {
	delay = 200,
	providers = {
		"lsp",
		"treesitter",
		"regex",
	},
	filetypes_denylist = {
		"markdown",
		"gitsigns-blame",
		"codecompanion",
	},
}

return {
	src = "https://github.com/RRethy/vim-illuminate",
	data = {
		enabled = true,
		setup = function()
			require("illuminate").configure(OPTS)
		end,
	},
}
