return {
	{
		desc = "Rename symbol",
		mode = "n",
		keys = "<leader>rn",
		cmd = vim.lsp.buf.rename,
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
