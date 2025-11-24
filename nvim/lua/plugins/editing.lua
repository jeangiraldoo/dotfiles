---@type PluginSpec[]
return {
	{
		src = "https://github.com/kylechui/nvim-surround",
		data = {
			enabled = true,
			setup = function()
				require("nvim-surround").setup({})
			end,
		},
	},
	{
		src = "https://github.com/jeangiraldoo/codedocs.nvim",
		data = {
			keymaps = {
				{
					desc = "Insert code annotation",
					mode = "n",
					keys = "<leader>sa",
					cmd = "<plug>Codedocs",
				},
			},
		},
	},
}
