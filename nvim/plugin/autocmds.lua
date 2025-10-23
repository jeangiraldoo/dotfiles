local AUTOCMDS = {
	-- Code editing
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

			if not (client and client:supports_method("textDocument/completion")) then
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
		cmd = function(event)
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
	-- Session management
	{
		desc = "Load view",
		event = "BufWinEnter",
		pattern = "*",
		cmd = "silent! loadview",
	},
	{
		desc = "Make view",
		event = "BufWinLeave",
		pattern = "*",
		cmd = "silent! mkview",
	},
	{
		desc = "Reload config",
		event = "BufWritePost",
		pattern = "*/nvim/*.lua",
		cmd = "silent source %",
	},
	-- UI
	{
		desc = "Highlight yanked line",
		pattern = "*",
		event = "TextYankPost",
		cmd = function()
			vim.highlight.on_yank({
				timeout = 200,
				higroup = "YankLine",
			})
		end,
	},
	{
		desc = "Start Treesitter syntax highlight",
		event = "FileType",
		cmd = function(args)
			pcall(vim.treesitter.start, args.buf)
		end,
	},
	{
		desc = "Automatically split help buffers to the right",
		pattern = "help",
		event = "FileType",
		cmd = "wincmd L",
	},
}

for _, autocmd in ipairs(AUTOCMDS) do
	vim.api.nvim_create_autocmd(autocmd.event, {
		pattern = autocmd.pattern or "*",
		command = type(autocmd.cmd) == "string" and autocmd.cmd or nil,
		callback = type(autocmd.cmd) == "function" and autocmd.cmd or nil,
		desc = autocmd.desc,
	})
end
