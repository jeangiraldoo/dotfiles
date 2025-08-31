return {
	{
		name = "nvim-treesitter",
		enabled = false,
		author = "nvim-treesitter",
		version = "main",
		remove_name_suffix = true,
		require_name = "nvim-treesitter.configs",
		opts = {
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
			},
		},
	},
	{
		name = "nvim-treesitter-context",
		author = "nvim-treesitter",
		remove_name_suffix = true,
	},
}
