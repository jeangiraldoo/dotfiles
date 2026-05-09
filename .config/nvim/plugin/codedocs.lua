vim.pack.add {
	{
		src = "https://github.com/jeangiraldoo/codedocs.nvim",
	},
}

require("codedocs").setup {
	debug = false,
}

vim.keymap.set("n", "<leader>aa", "<cmd>Codedocs<CR>", { desc = "Insert code annotation", silent = true })
vim.keymap.set("n", "<leader>ac", "<cmd>Codedocs comment<CR>", { desc = "Insert comment annotation", silent = true })
