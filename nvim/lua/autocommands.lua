return {
	["Load view"] = {
		event = "BufWinEnter",
		pattern = "*",
		command = "silent! loadview",
	},
	["Make view"] = {
		event = "BufWinLeave",
		pattern = "*",
		command = "silent! mkview",
	},
	["Update status bar diagnostics"] = {
		event = "DiagnosticChanged",
		command = "redrawstatus",
	},
}
