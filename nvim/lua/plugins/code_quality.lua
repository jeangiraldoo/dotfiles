return {
	{
		src = "https://github.com/stevearc/conform.nvim",
		data = {
			enabled = true,
			setup = function()
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
		},
	},
	{
		src = "https://github.com/mfussenegger/nvim-lint",
		data = {
			enabled = true,
			setup = function()
				local nvim_lint_config = require("lint")

				nvim_lint_config.linters_by_ft = {
					markdown = {
						"markdownlint",
					},
					rust = {
						"clippy",
					},
					lua = {
						"luacheck",
					},
					python = {
						"ruff",
					},
					["yaml.github"] = {
						"actionlint",
					},
				}

				local linters_config = nvim_lint_config.linters

				linters_config.luacheck.args = {
					"--formatter",
					"plain",
					"--codes",
					"--ranges",
					"-",
					"--globals",
					"vim",
				}

				vim.api.nvim_create_autocmd("BufWritePost", {
					callback = function()
						require("lint").try_lint()
					end,
				})
			end,
		},
	},
}
