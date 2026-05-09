return {
	cmd = {
		"ty",
		"server",
	},
	root_markers = {
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		"pyrightconfig.json",
		".git",
	},
	filetypes = {
		"python",
	},
	single_file_support = true,
	settings = {
		ty = {
			configuration = {
				rules = {
					["division-by-zero"] = "warn",
				},
			},
		},
	},
}
