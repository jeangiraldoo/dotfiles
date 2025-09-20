local OPTS = {
	keymaps = {
		normal = "<leader>ls",
		visual = "<leader>ls",
		change = "<leader>rs",
	},
}

return {
	src = "https://github.com/kylechui/nvim-surround",
	data = {
		enabled = true,
		setup = function()
			require("nvim-surround").setup(OPTS)
		end,
	},
}
