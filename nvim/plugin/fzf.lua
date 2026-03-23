vim.pack.add {
	{
		src = "https://github.com/nvim-tree/nvim-web-devicons", -- Dependency
	},
	{
		src = "https://github.com/ibhagwan/fzf-lua",
	},
}

vim.keymap.set("n", "<leader><leader>", ":FzfLua files<CR>", { desc = "Open fuzzy finder", silent = true })
