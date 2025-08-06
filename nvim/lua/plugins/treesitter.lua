return {
	"nvim-treesitter",
	config = function()
		require("nvim-treesitter.configs").setup({
			-- highlight = {
			-- 	enable = true,
			-- },
			ensure_installed = {
				"java",
				"javascript",
				"php",
				"ruby",
				"rust",
				"typst",
				"python",
				"typst",
				"html",
				"go",
				"c",
				"cpp",
				"yaml",
			},
		})
	end,
}
