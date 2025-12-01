---@type PluginSpec[]
return {
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		data = {
			enabled = true,
			setup = function()
				require("nvim-treesitter.configs").setup({
					ensure_installed = {
						"java",
						"javascript",
						"php",
						"ruby",
						"rust",
						"typst",
						"python",
						"typst",
						"html",
						"go",
					},
				})
			end,
		},
	},
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter-context",
		data = {
			enabled = true,
			setup = function()
				vim.defer_fn(function()
					vim.api.nvim_set_hl(0, "TreesitterContext", {
						bg = "#6d6e18",
						italic = true,
						bold = true,
					})
				end, 50)
			end,
			keymaps = {
				{
					desc = "Go to code context",
					mode = "n",
					keys = "<leader>sc",
					cmd = function()
						require("treesitter-context").go_to_context(vim.v.count1)
					end,
				},
			},
		},
	},
	{
		src = "https://github.com/ThePrimeagen/refactoring.nvim",
		data = {
			enabled = true,
			keymaps = {
				{
					desc = "Extract variable",
					mode = "x",
					keys = "<leader>rv",
					cmd = ":Refactor extract_var ",
				},
				{
					desc = "Inline variable",
					mode = "n",
					keys = "<leader>rV",
					cmd = ":Refactor inline_var<CR>",
				},
				{
					desc = "Extract function",
					mode = "x",
					keys = "<leader>rf",
					cmd = ":Refactor extract ",
				},
				{
					desc = "Inline function",
					mode = "n",
					keys = "<leader>rF",
					cmd = ":Refactor inline_func<CR>",
				},
			},
		},
	},
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
						typescript = { "prettier" },
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
