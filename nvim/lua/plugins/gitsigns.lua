return {
	name = "gitsigns",
	author = "lewis6991",
	opts = {
		signcolumn = true,
		current_line_blame_opts = {
			delay = 0,
		},
		current_line_blame_formatter = "  <author> -> <summary> •  <author_time:%d-%b-%Y> • 󰜛 <abbrev_sha>",
		current_line_blame_formatter_nc = " Not commited yet",
		gh = true,
	},
}
