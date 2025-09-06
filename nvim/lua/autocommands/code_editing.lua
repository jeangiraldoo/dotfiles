return {
	{
		desc = "Display function signature help when typing arguments",
		event = "TextChangedI",
		pattern = "*",
		cmd = function()
			local col = vim.fn.col(".") - 1
			if col > 0 then
				local char = vim.fn.getline("."):sub(col, col)

				local is_typing_function_args = (char == "(" or char == ",")
				if is_typing_function_args then
					vim.lsp.buf.signature_help()
				end
			end
		end,
	},
	{
		desc = "Lint the current file on save",
		event = "BufWritePost",
		pattern = "*",
		cmd = function()
			require("lint").try_lint()
		end,
	},
}
