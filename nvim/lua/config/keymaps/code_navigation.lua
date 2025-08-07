return {
	{
		desc = "List references to symbol",
		mode = "n",
		keys = "<leader>gr",
		cmd = vim.lsp.buf.references,
	},
	{
		desc = "Go to symbol declaration",
		mode = "n",
		keys = "<leader>gd",
		cmd = vim.lsp.buf.definition,
	},
	{
		desc = "Go to call",
		mode = "n",
		keys = "<leader>gf",
		cmd = vim.lsp.buf.outgoing_calls,
	},
	{
		desc = "Go to next word occurrence",
		mode = "n",
		keys = "<leader>gn",
		cmd = function()
			require("illuminate").goto_next_reference(true)
		end,
	},
	{
		desc = "Go to previous word occurrence",
		mode = "n",
		keys = "<leader>gN",
		cmd = function()
			require("illuminate").goto_prev_reference(true)
		end,
	},
}
