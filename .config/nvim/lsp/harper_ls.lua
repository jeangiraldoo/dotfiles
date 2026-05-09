return {
	cmd = {
		"harper-ls",
		"-s",
	},
	root_markers = { ".git" },
	filetypes = {
		"markdown",
	},
	single_file_support = true,
	settings = {
		["harper_ls"] = {
			linters = {
				SpelledNumbers = true,
				BoringWords = true,
				LinkingVerbs = true,
			},
		},
	},
}
