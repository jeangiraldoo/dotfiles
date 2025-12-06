---@type PluginSpec[]
return {
	{
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
	},
	{
		src = "https://github.com/stevearc/oil.nvim",
		data = {
			enabled = true,
			dependencies = {
				{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
			},
			setup = function()
				require("oil").setup({
					default_file_explorer = true,
					columns = {
						"icon",
					},
					skip_confirm_for_simple_edits = true,
					view_options = {
						show_hidden = true,
					},
				})
			end,
			keymaps = {
				{
					desc = "Open file manager",
					mode = "n",
					keys = "<leader>fm",
					cmd = ":Oil <CR>",
				},
			},
		},
	},
}
