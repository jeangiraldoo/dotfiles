return {
	cmd = {
		"basedpyright-langserver",
		"--stdio",
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
		basedpyright = {
			analysis = {
				inlayHints = {
					callArgumentNamesMatching = true,
				},
				diagnosticSeverityOverrides = {
					reportMissingParameterType = "none",
					reportMissingTypeArgument = "warning",
				},
				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = true,
				autoFormatStrings = true,
				autoImportCompletions = true,
			},
		},
	},
}
