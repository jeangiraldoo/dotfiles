return {
	"mfussenegger/nvim-lint",
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
}
