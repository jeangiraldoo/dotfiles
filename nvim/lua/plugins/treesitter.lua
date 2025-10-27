local OPTS = {
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
}

return {
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		data = {
			enabled = true,
			setup = function()
				require("nvim-treesitter.configs").setup(OPTS)
			end,
		},
	},
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter-context",
		data = {
			enabled = true,
			setup = function()
				vim.defer_fn(function()
					vim.api.nvim_set_hl(0, "TreesitterContext", {
						bg = "#003767",
						italic = true,
						bold = true,
					})
				end, 50)
			end,
			keymaps = {
				{
					desc = "Go to code context",
					mode = "n",
					keys = "<leader>sc",
					cmd = function()
						require("treesitter-context").go_to_context(vim.v.count1)
					end,
				},
			},
		},
	},
}
