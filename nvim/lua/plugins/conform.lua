return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				rust = { "rustfmt" },
				python = { "ruff_format" },
			},
			format_on_save = {
				timeout_ms = 1000,
				lsp_format = "fallback",
			},
			notify_on_error = true,
			notify_no_formatters = true,
			log_level = vim.log.levels.DEBUG,
		})
	end,
}
