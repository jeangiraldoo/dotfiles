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
		desc = "Update status bar diagnostics",
		event = "DiagnosticChanged",
		pattern = "*",
		cmd = "redrawstatus",
	},
}
