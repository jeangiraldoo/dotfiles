vim.pack.add {
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
	},
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter-context",
	},
}

require("nvim-treesitter")
	.install({
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
		"yaml",
	})
	:wait(300000) -- wait max. 5 minutes

vim.defer_fn(function()
	vim.api.nvim_set_hl(0, "TreesitterContext", {
		bg = "#6d6e18",
		italic = true,
		bold = true,
	})
end, 50)

require("utils").editor.set_keymaps {
	{
		desc = "Go to code context",
		mode = "n",
		keys = "<leader>sc",
		cmd = function()
			require("treesitter-context").go_to_context(vim.v.count1)
		end,
	},
}
