vim.diagnostic.config({
	virtual_text = {
		prefix = "◆",
		spacing = 2,
	},
	float = {
		scope = "line",
		border = "rounded",
		source = "always",
		header = "診断メッセージ",
	},
	signs = false,
	underline = true,
	severity_sort = true,
})
