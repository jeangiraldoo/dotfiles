return {
	{
		name = "vim-illuminate",
		author = "RRethy",
		-- enabled = false,
		remove_name_suffix = true,
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
	},
}
