---@type PluginSpec[]
return {
	{
		src = "https://github.com/sphamba/smear-cursor.nvim",
		data = {
			enabled = true,
			setup = function()
				require("smear_cursor").setup({
					cursor_color = "#ff1f9d",
					stiffness = 0.3, -- How fast the smear's head moves towards the target
					trailing_stiffness = 0.15, -- How fast the smear's tail moves towards the target
					trailing_exponent = 5, -- Controls if middle points are closer to the head or the tail
					hide_target_hack = true, -- Attempt to hide the real cursor by drawing a character below it
					gamma = 1,
				})
			end,
		},
	},
	{
		src = "https://github.com/RRethy/vim-illuminate",
		data = {
			enabled = true,
			setup = function()
				require("illuminate").configure({
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
				})
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
	},
}
