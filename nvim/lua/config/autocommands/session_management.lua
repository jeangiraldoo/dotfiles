return {
	{
		desc = "Load view",
		event = "BufWinEnter",
		pattern = "*",
		cmd = "silent! loadview",
	},
	{
		desc = "Make view",
		event = "BufWinLeave",
		pattern = "*",
		cmd = "silent! mkview",
	},
	{
		desc = "Reload config",
		event = "BufWritePost",
		pattern = "*/nvim/*",
		cmd = "silent source %",
	},
}
