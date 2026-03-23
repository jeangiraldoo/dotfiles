vim.pack.add {
	{
		src = "https://github.com/jeangiraldoo/codedocs.nvim",
	},
}

require("codedocs").setup {
	debug = true,
}

vim.keymap.set("n", "<leader>sa", "<plug>Codedocs", { desc = "Insert code annotation", silent = true })
