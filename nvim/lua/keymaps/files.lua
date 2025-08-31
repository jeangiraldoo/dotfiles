return {
	{
		desc = "Open fuzzy finder",
		mode = "n",
		keys = "<leader>ff",
		cmd = ":FzfLua files<CR>",
	},
	{
		desc = "Open file manager",
		mode = "n",
		keys = "<leader>fm",
		cmd = ":Oil <CR>",
	},
	{
		desc = "Display file tree",
		mode = "n",
		keys = "<leader>fM",
		cmd = ":Neotree right toggle<CR>",
	},
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
	{
		desc = "Comment line/s",
		mode = { "n", "v" },
		keys = "<leader>cc",
		cmd = function()
			if vim.fn.mode():match("v") then
				local keys = vim.api.nvim_replace_termcodes("gc", true, false, true)
				vim.api.nvim_feedkeys(keys, "x", false)
			else
				vim.cmd("normal gcc")
			end
		end,
	},
	{
		desc = "Swap lines above",
		mode = "n",
		keys = "<leader>la",
		cmd = ":m .-2<CR>==",
	},
	{
		desc = "Swap lines below",
		mode = "n",
		keys = "<leader>lb",
		cmd = ":m .+1<CR>==",
	},
	{
		desc = "Duplicate lines",
		mode = "v",
		keys = "<leader>ld",
		cmd = ":y<CR>'>p",
	},
	{
		desc = "Duplicate line",
		mode = "n",
		keys = "<leader>ld",
		cmd = ":t.<CR>",
	},
	{
		desc = "Add new empty line",
		mode = "n",
		keys = "O",
		cmd = "o<Esc>",
	},
	{
		desc = "Copy to clipboard",
		mode = { "n", "v" },
		keys = "<leader>y",
		cmd = ":y+ <CR>",
	},
	{
		desc = "Paste from clipboard",
		mode = { "n", "v" },
		keys = "<leader>p",
		cmd = '"+p',
	},
	{
		desc = "Select all lines",
		mode = { "n", "v" },
		keys = "<leader>al",
		cmd = "ggvG",
	},
}
