return {
	{
		desc = "Rename symbol",
		mode = "n",
		keys = "<leader>rn",
		cmd = vim.lsp.buf.rename,
	},
	{
		desc = "Extract occurrences of a selected expression to its own variable",
		mode = "x",
		keys = "<leader>rv",
		cmd = ":Refactor extract_var ",
	},
	{
		desc = "Replace all occurrences of a variable with its value",
		mode = "n",
		keys = "<leader>rV",
		cmd = ":Refactor inline_var<CR>",
	},
	{
		desc = "Extract code to a separate function",
		mode = "x",
		keys = "<leader>rf",
		cmd = ":Refactor extract ",
	},
	{
		desc = "Replace calls to the function declaration under the cursor with its body",
		mode = "n",
		keys = "<leader>rF",
		cmd = ":Refactor inline_func<CR>",
	},
	{
		desc = "Empty out string under the cursor",
		mode = "n",
		keys = "<leader>rt",
		cmd = function()
			local node = vim.treesitter.get_node()

			if node:type() == "string_content" then
				local bufnr = vim.api.nvim_get_current_buf()
				local start_row, start_col, end_row, end_col = node:range()

				local empty_string = ""

				vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, { empty_string })
			end
		end,
	},
}
