return {
	cmd = {
		"vscode-html-language-server",
		"--stdio",
	},

	filetypes = {
		"html",
	},
	root_markers = {
		"tsconfig.json",
		"jsconfig.json",
		"package.json",
		".git",
	},
	single_file_support = true,
	settings = {
		-- Empty for now
	},
}
