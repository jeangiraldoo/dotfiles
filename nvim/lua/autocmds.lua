local AUTOCMDS = {
	-- Code editing
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
				print "Supports"
				vim.lsp.document_color.enable(true, args.buf, {
					style = "virtual",
				})
			end
		end,
	},
	-- Session management
	{
		desc = "Load view",
		event = "BufWinEnter",
		pattern = "*",
		command = "silent! loadview",
	},
	{
		desc = "Make view",
		event = "BufWinLeave",
		pattern = "*",
		command = "silent! mkview",
	},
	-- UI
	{
		desc = "Highlight yanked line",
		pattern = "*",
		event = "TextYankPost",
		callback = function()
			vim.highlight.on_yank {
				timeout = 200,
				higroup = "YankLine",
			}
		end,
	},
	{
		desc = "Start Treesitter syntax highlight",
		event = "FileType",
		callback = function(args)
			pcall(vim.treesitter.start, args.buf)
		end,
	},
	{
		desc = "Open help buffers in a vertical split",
		event = "BufWinEnter",
		callback = function()
			if vim.bo.buftype ~= "help" then
				return
			end

			pcall(vim.cmd, "wincmd L")
		end,
	},
}

for _, autocmd in ipairs(AUTOCMDS) do
	-- Passing the autocmd table with an `event` field will result in an error
	local autocmd_event = autocmd.event
	autocmd.event = nil

	vim.api.nvim_create_autocmd(autocmd_event, autocmd)
end
