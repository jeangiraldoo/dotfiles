return {
	{
		desc = "Move to window left",
		mode = "n",
		keys = "<leader>wh",
		cmd = "<C-w>h",
	},
	{
		desc = "Move to window below",
		mode = "n",
		keys = "<leader>wj",
		cmd = "<C-w>j",
	},
	{
		desc = "Move to window above",
		mode = "n",
		keys = "<leader>wk",
		cmd = "<C-w>k",
	},
	{
		desc = "Move to window right",
		mode = "n",
		keys = "<leader>wl",
		cmd = "<C-w>l",
	},
	{
		desc = "Vertical split",
		mode = "n",
		keys = "<leader>ws",
		cmd = ":vsplit <CR>",
	},
	{
		desc = "Vertical split with Fuzzy Finder",
		mode = "n",
		keys = "<leader>sV",
		cmd = ":vsplit<CR>:normal ;ff<CR>",
	},
	{
		desc = "Increase VSplit",
		mode = "n",
		keys = "<C-Up>",
		cmd = ":vertical resize +3 <CR>",
	},
	{
		desc = "Decrease VSplit",
		mode = "n",
		keys = "<C-Down>",
		cmd = ":vertical resize -3 <CR>",
	},
}
