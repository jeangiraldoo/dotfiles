return {
	"RRethy/vim-illuminate",
	config = function()
		require("illuminate").configure({
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
		})
	end,
}
