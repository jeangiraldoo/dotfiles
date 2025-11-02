vim.diagnostic.config({
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
