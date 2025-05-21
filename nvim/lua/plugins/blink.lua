return {
	"saghen/blink.cmp",
	version = "0.11.0",
	opts = {
		keymap = {
			preset = "default",
			["<C-a>"] = { "accept" },
			["<C-j>"] = { "select_next" },
			["<C-k>"] = { "select_prev" },
		},
		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "monocraft",
		},
		sources = {
			default = { "lsp", "path", "buffer" },
		},
	},
	opts_extend = { "sources.default" },
}
