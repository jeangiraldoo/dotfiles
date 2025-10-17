return {
	{
		desc = "Set up LSP CodeLens",
		pattern = "*",
		event = "LspAttach",
		cmd = function(event)
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client ~= nil and client.server_capabilities.codeLensProvider then
				vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "CursorHold" }, {
					desc = "Auto-refresh CodeLens",
					buffer = event.buf,
					callback = function()
						vim.lsp.codelens.refresh()
					end,
				})
				vim.lsp.codelens.refresh()
			end
		end,
	},
}
