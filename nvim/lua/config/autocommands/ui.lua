return {
	{
		desc = "Highlight yanked line",
		pattern = "*",
		event = "TextYankPost",
		cmd = function()
			vim.highlight.on_yank({
				timeout = 200,
				higroup = "YankLine",
			})
		end,
	},
	{
		desc = "Update status bar diagnostics",
		event = "DiagnosticChanged",
		pattern = "*",
		cmd = "redrawstatus",
	},
	{
		desc = "Start Treesitter syntax highlight",
		event = "FileType",
		pattern = {
			"markdown",
			"typst",
			"html",
			"javascript",
			"lua",
			"python",
			"rust",
			"go",
			"ruby",
			"java",
			"php",
		},
		cmd = function(args)
			pcall(vim.treesitter.start, args.buf)
		end,
	},
	{
		desc = "Automatically split help buffers to the right",
		pattern = "help",
		event = "FileType",
		cmd = "wincmd L",
	},
}
