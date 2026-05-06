vim.lsp.log.set_level "off"
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

vim.keymap.set("n", "<leader>sf", vim.lsp.buf.outgoing_calls, { desc = "Go to call" })
vim.keymap.set("n", "<leader>th", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Go to call" })

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "Set up LSP autocompletion",
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)

		if client and client:supports_method "textDocument/completion" then
			vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
			vim.o.complete = ""
		end
	end,
})

vim.keymap.set("i", "<C-s>", function()
	if vim.fn.pumvisible() == 1 then
		vim.api.nvim_input(vim.api.nvim_replace_termcodes("<C-e>", true, false, true)) ---Close popup menu
	end

	vim.lsp.buf.signature_help()
end, { desc = "Show signature help" })

vim.api.nvim_create_autocmd("CmdlineChanged", {
	desc = "Set up command line autocompletion",
	pattern = { ":", "/", "?" },
	callback = function()
		local cmd = vim.fn.getcmdline()

		if cmd:sub(1, 1) == "!" or cmd:match "^%s*['<,>]*!+" then
			return
		end

		vim.fn.wildtrigger()
	end,
})
