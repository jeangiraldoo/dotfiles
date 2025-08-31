vim.lsp.log.set_level("off")
vim.lsp.log.set_format_func(vim.inspect)

vim.lsp.enable({
	"lua_ls",
	"rust_analyzer",
	"basedpyright",
	"harper_ls",
	"marksman",
	"tinymist",
	"yaml_ls",
})

-- Nerd Font icons for each LSP completion item type
vim.lsp.protocol.CompletionItemKind = {
	"󰉿 Text",
	" Method",
	"ƒ Function",
	" Constructor",
	"󰜢 Field",
	" Variable",
	" Class",
	" Interface",
	"󰏖 Module",
	"󰜢 Property",
	"󰑭 Unit",
	"󰎠 Value",
	" Enum",
	"󰌋 Keyword",
	" Snippet",
	"󰏘 Color",
	"󰈙 File",
	"󰈇 Reference",
	"󰉋 Directory",
	" EnumMember",
	" Constant",
	" Struct",
	" Event",
	"󰆕 Operator",
	"󰅲 TypeParameter",
}
