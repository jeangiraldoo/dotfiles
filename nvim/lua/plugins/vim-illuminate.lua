local OPTS = {
	delay = 200,
	providers = {
		"lsp",
		"treesitter",
		"regex",
	},
	filetypes_denylist = {
		"markdown",
		"gitsigns-blame",
		"codecompanion",
	},
}

---@type PluginSpec
return {
	src = "https://github.com/RRethy/vim-illuminate",
	data = {
		enabled = true,
		setup = function()
			require("illuminate").configure(OPTS)
			vim.defer_fn(function()
				vim.api.nvim_set_hl(0, "IlluminatedWordWrite", {
					bg = "#4c3f39",
					bold = true,
				})
				vim.api.nvim_set_hl(0, "IlluminatedWordRead", {
					bg = "#39414c",
					bold = true,
				})
			end, 50)
		end,
		keymaps = {
			{
				desc = "Go to next word occurrence",
				mode = "n",
				keys = "<leader>sn",
				cmd = function()
					require("illuminate").goto_next_reference(true)
				end,
			},
			{
				desc = "Go to previous word occurrence",
				mode = "n",
				keys = "<leader>sN",
				cmd = function()
					require("illuminate").goto_prev_reference(true)
				end,
			},
		},
	},
}
