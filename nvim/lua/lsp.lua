local utils = require "utils"

vim.lsp.log.set_level "off"
vim.lsp.log.set_format_func(vim.inspect)
vim.lsp.enable {
	"lua_ls",
	"rust_analyzer",
	"ty",
	"tsgo",
	"css_ls",
	"html_ls",
	"harper_ls",
	"marksman",
	"tinymist",
	"yaml_ls",
}

utils.editor.set_keymaps {
	{
		desc = "Go to call",
		mode = "n",
		keys = "<leader>sf",
		cmd = vim.lsp.buf.outgoing_calls,
	},
	{
		desc = "Toggle inlay hints",
		mode = "n",
		keys = "<leader>sh",
		cmd = function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end,
	},
}

utils.editor.set_autocmds {
	{
		desc = "Set up LSP autocompletion",
		event = "LspAttach",
		callback = function(event)
			local client = vim.lsp.get_client_by_id(event.data.client_id)

			if not (client and client:supports_method "textDocument/completion") then
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
	{
		desc = "Set up LSP CodeLens",
		pattern = "*",
		event = "LspAttach",
		callback = function(event)
			local client = vim.lsp.get_client_by_id(event.data.client_id)

			if not (client and client.server_capabilities.codeLensProvider) then
				return
			end

			vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "CursorHold" }, {
				desc = "Auto-refresh CodeLens",
				buffer = event.buf,
				callback = vim.lsp.codelens.refresh,
			})
		end,
	},
	{
		desc = "Enable LSP-based colour highlighting",
		event = "LspAttach",
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)

			if client:supports_method "textDocument/documentColor" then
				vim.lsp.document_color.enable(true, args.buf, {
					style = "virtual",
				})
			end
		end,
	},
}
