---@type PluginSpec
return {
	src = "https://github.com/kylechui/nvim-surround",
	data = {
		enabled = true,
		setup = function()
			require("nvim-surround").setup({})
		end,
	},
}
