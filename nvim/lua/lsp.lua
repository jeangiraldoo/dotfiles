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

vim.lsp.codelens.enable(true)
vim.lsp.document_color.enable(true, nil, { --- Enabled by default, but there's no other way to explicitely set the style
	style = "virtual",
})

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
		end,
	},
}
