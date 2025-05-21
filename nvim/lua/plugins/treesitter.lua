return {
	"nvim-treesitter",
	config = function()
		require("nvim-treesitter.configs").setup({
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
				"go"
			}
		})
	end
}
