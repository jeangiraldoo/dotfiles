return {
	{
		desc = "Enable autocompletion",
		pattern = "*",
		event = "LspAttach",
		cmd = function(ev)
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			if client ~= nil and client:supports_method("textDocument/completion") then
				vim.lsp.completion.enable(true, client.id, ev.buf, {
					autotrigger = true,
					convert = function(item)
						return { abbr = item.label:gsub("%b()", "") }
					end,
				})
			end
		end,
	},
	{
		desc = "Display autocomplete window while typing",
		pattern = "*",
		event = "TextChangedI",
		cmd = vim.lsp.completion.get,
	},
}
