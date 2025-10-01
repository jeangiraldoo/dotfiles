local OPTS = {
	default_file_explorer = true,
	columns = {
		"permissions",
		"icon",
	},
}

return {
	src = "https://github.com/stevearc/oil.nvim",
	data = {
		enabled = true,
		dependencies = {
			{ src = "https://github.com/nvim-web-devicons" },
		},
		setup = function()
			require("oil").setup(OPTS)
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
}
