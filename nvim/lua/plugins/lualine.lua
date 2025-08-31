return {
	{
		name = "lualine",
		author = "nvim-lualine",
		dependencies = {
			{
				name = "nvim-web-devicons",
				author = "nvim-tree",
				remove_name_suffix = true,
			},
		},
		opts = {
			theme = "gruvbox",
			sections = {
				lualine_a = { "branch", "diff" },
				lualine_b = { "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = { "encoding", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		},
	},
}
