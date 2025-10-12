local OPTS = {
	transparent = true,
}

return {
	src = "https://github.com/folke/tokyonight.nvim",
	data = {
		enabled = true,
		setup = function()
			require("tokyonight").setup(OPTS)
		end,
	},
}
