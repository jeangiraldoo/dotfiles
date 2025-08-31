return {
	name = "octo",
	author = "pwntester",
	dependencies = {
		{
			name = "plenary",
			author = "nvim-lua",
		},
		{
			name = "fzf-lua",
			author = "ibhagwan",
			remove_name_suffix = true,
		},
		{
			name = "nvim-web-devicons",
			author = "nvim-tree",
			remove_name_suffix = true,
		},
	},
	opts = {
		picker = "fzf-lua",
	},
}
