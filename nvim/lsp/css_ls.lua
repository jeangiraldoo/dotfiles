return {
	cmd = {
		"vscode-css-language-server",
		"--stdio",
	},

	filetypes = {
		"css",
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
