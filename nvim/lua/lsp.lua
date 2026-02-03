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
