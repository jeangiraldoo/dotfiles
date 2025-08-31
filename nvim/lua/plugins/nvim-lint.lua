return {
	{
		name = "nvim-lint",
		author = "mfussenegger",
		remove_name_suffix = true,
		config = function()
			require("lint").linters_by_ft = {
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

			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
}
