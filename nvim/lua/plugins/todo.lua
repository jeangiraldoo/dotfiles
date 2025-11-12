---@type PluginSpec
return {
	src = "https://github.com/folke/todo-comments.nvim",
	dependencies = {
		{ src = "https://github.com/nvim-lua/plenary.nvim" },
	},
	data = {
		enabled = true,
		setup = function()
			require("todo-comments").setup({})
		end,
	},
}
