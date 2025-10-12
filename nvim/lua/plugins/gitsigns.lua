local OPTS = {
	signcolumn = true,
	current_line_blame_opts = {
		delay = 0,
	},
	current_line_blame_formatter = "  <author> -> <summary> •  <author_time:%d-%b-%Y> • 󰜛 <abbrev_sha>",
	current_line_blame_formatter_nc = " Not commited yet",
	gh = true,
}

return {
	src = "https://github.com/lewis6991/gitsigns.nvim",
	data = {
		enabled = true,
		setup = function()
			require("gitsigns").setup(OPTS)
		end,
		keymaps = {
			{
				desc = "Toggle inline Git blame",
				mode = "n",
				keys = "<leader>pb",
				cmd = ":Gitsigns toggle_current_line_blame<CR>",
			},
			{
				desc = "Open buffer Git blame",
				mode = "n",
				keys = "<leader>pB",
				cmd = ":Gitsigns blame<CR>",
			},
		},
	},
}
