return {
	src = "https://github.com/ibhagwan/fzf-lua",
	data = {
		enabled = true,
		dependencies = {
			{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
		},
		keymaps = {
			{
				desc = "Open fuzzy finder",
				mode = "n",
				keys = "<leader>ff",
				cmd = ":FzfLua files<CR>",
			},
		},
	},
}
