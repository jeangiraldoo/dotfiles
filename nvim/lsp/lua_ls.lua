return {
	cmd = {
		"lua-language-server",
	},
	root_markers = {
		".git",
		"stylua.toml",
		".stylua.toml",
		".luacheckrc",
	},
	filetypes = {
		"lua",
	},
	single_file_support = true,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
}
