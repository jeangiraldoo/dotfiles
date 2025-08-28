return {
	{
		desc = "Vertical split",
		mode = "n",
		keys = "<leader>ws",
		cmd = ":vsplit <CR>",
	},
	{
		desc = "Increase vertical split",
		mode = "n",
		keys = "<C-Up>",
		cmd = ":vertical resize +3 <CR>",
	},
	{
		desc = "Decrease vertical split",
		mode = "n",
		keys = "<C-Down>",
		cmd = ":vertical resize -3 <CR>",
	},
	{
		desc = "Move to left split",
		mode = "n",
		keys = "<leader>wh",
		cmd = "<C-w>h",
	},
	{
		desc = "Move to split below",
		mode = "n",
		keys = "<leader>wj",
		cmd = "<C-w>j",
	},
	{
		desc = "Move to split above",
		mode = "n",
		keys = "<leader>wk",
		cmd = "<C-w>k",
	},
	{
		desc = "Move to right split",
		mode = "n",
		keys = "<leader>wl",
		cmd = "<C-w>l",
	},
}
