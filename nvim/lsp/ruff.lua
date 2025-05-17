return {
	cmd = {
		"ruff",
		"server",
	},
	root_markers = {
		".git",
		"pyproject.toml",
		"requirements.txt",
	},
	filetypes = {
		"python",
	},
	single_file_support = true,
}
