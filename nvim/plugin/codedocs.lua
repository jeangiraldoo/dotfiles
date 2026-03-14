vim.pack.add {
	{
		src = "https://github.com/jeangiraldoo/codedocs.nvim",
	},
}

require("codedocs").setup {
	debug = true,
}

require("utils").editor.set_keymaps {
	{
		desc = "Insert code annotation",
		mode = "n",
		keys = "<leader>sa",
		cmd = "<plug>Codedocs",
	},
}
