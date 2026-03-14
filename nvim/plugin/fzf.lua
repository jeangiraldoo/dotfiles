vim.pack.add {
	{
		src = "https://github.com/nvim-tree/nvim-web-devicons", -- Dependency
	},
	{
		src = "https://github.com/ibhagwan/fzf-lua",
	},
}

require("utils").editor.set_keymaps {
	{
		desc = "Open fuzzy finder",
		mode = "n",
		keys = "<leader><leader>",
		cmd = ":FzfLua files<CR>",
	},
}
