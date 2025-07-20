return {
	{
		desc = "Close file",
		mode = "n",
		keys = "<leader>q",
		cmd = ":q<CR>",
	},
	{
		desc = "Save file",
		mode = "n",
		keys = "<leader>w",
		cmd = ":w<CR>",
	},
	{
		desc = "Save and close file",
		mode = "n",
		keys = "<leader>ww",
		cmd = ":wq<CR>",
	},
	{
		desc = "Create fold",
		mode = { "n", "v" },
		keys = "<leader>fc",
		cmd = "zf",
	},
	{
		desc = "Delete fold",
		mode = { "n", "v" },
		keys = "<leader>fd",
		cmd = "zd",
	},
	{
		desc = "Toogle fold",
		mode = "n",
		keys = "<leader>ft",
		cmd = "za",
	},
}
