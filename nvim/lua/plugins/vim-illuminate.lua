return {
	"RRethy/vim-illuminate",
	config = function()
		vim.api.nvim_set_hl(0, "IlluminatedWordWrite", {
			bold = true,
			bg = "#4c3f39",
		})

		vim.api.nvim_set_hl(0, "IlluminatedWordRead", {
			bold = true,
			bg = "#39414c",
		})

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
