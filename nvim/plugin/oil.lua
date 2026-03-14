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

require("utils").editor.set_keymaps {
	{
		desc = "Open file manager",
		mode = "n",
		keys = "<leader>fm",
		cmd = ":Oil <CR>",
	},
}
