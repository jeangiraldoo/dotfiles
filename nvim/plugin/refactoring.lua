vim.pack.add {
	{
		src = "https://github.com/ThePrimeagen/refactoring.nvim",
	},
}

require("utils").editor.set_keymaps {
	{
		desc = "Extract variable",
		mode = "x",
		keys = "<leader>rv",
		cmd = ":Refactor extract_var ",
	},
	{
		desc = "Inline variable",
		mode = "n",
		keys = "<leader>rV",
		cmd = ":Refactor inline_var<CR>",
	},
	{
		desc = "Extract function",
		mode = "x",
		keys = "<leader>rf",
		cmd = ":Refactor extract ",
	},
	{
		desc = "Inline function",
		mode = "n",
		keys = "<leader>rF",
		cmd = ":Refactor inline_func<CR>",
	},
}
