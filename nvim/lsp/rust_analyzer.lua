return {
	cmd = {
		"rust-analyzer",
	},
	root_markers = {
		".git",
		"Cargo.toml",
	},
	filetypes = {
		"rust",
	},
	single_file_support = true,
	settings = {
		["rust-analyzer"] = {
			diagnostics = {
				disabled = {
					"unlinked-file",
				},
			},
		},
	},
}
