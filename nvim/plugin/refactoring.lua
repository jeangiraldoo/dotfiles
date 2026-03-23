vim.pack.add {
	{
		src = "https://github.com/ThePrimeagen/refactoring.nvim",
	},
}

vim.keymap.set("n", "<leader>rv", ":Refactor extract_var ", { desc = "Extract variable", silent = true })
vim.keymap.set("n", "<leader>rV", ":Refactor inline_var<CR> ", { desc = "Inline variable", silent = true })
vim.keymap.set("n", "<leader>rf", ":Refactor extract ", { desc = "Extract function", silent = true })
vim.keymap.set("n", "<leader>rF", ":Refactor inline_func<CR> ", { desc = "Inline function", silent = true })
