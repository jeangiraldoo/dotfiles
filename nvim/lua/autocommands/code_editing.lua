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
	{
		desc = "Set up LSP autocompletion",
		event = "LspAttach",
		cmd = function(event)
			local client = vim.lsp.get_client_by_id(event.data.client_id)

			if not client or not client:supports_method("textDocument/completion") then
				return
			end

			vim.lsp.completion.enable(true, client.id, event.buf, {
				autotrigger = true,
				convert = function(item)
					return { abbr = item.label:gsub("%b()", "") }
				end,
			})

			vim.api.nvim_create_autocmd("TextChangedI", {
				desc = "Display autocomplete window while typing",
				callback = vim.lsp.completion.get,
			})
		end,
	},
}
