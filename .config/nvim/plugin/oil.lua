vim.pack.add {
	{
		src = "https://github.com/nvim-tree/nvim-web-devicons", -- Dependency
	},
	{
		src = "https://github.com/stevearc/oil.nvim",
	},
}

require("oil").setup {
	default_file_explorer = true,
	columns = {
		"icon",
	},
	skip_confirm_for_simple_edits = true,
	view_options = {
		show_hidden = true,
	},
}

vim.keymap.set("n", "<leader>fm", ":Oil <CR>", { desc = "Open file manager", silent = true })
