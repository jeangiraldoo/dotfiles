return {
	name = "nvim-lint",
	author = "mfussenegger",
	remove_name_suffix = true,
	config = function()
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

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
