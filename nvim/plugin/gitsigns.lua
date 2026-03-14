vim.pack.add {
	{
		src = "https://github.com/lewis6991/gitsigns.nvim",
	},
}

require("gitsigns").setup {
	current_line_blame_opts = {
		delay = 0,
	},
	current_line_blame_formatter = "  <author> -> <summary> •  <author_time:%d-%b-%Y> • 󰜛 <abbrev_sha>",
	current_line_blame_formatter_nc = " Not commited yet",
}

require("utils").editor.set_keymaps {
	{
		desc = "Toggle inline Git blame",
		mode = "n",
		keys = "<leader>gb",
		cmd = ":Gitsigns toggle_current_line_blame<CR>",
	},
	{
		desc = "Open buffer Git blame",
		mode = "n",
		keys = "<leader>gB",
		cmd = ":Gitsigns blame<CR>",
	},
}
