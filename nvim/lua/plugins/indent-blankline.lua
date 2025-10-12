return {
	src = "https://github.com/lukas-reineke/indent-blankline.nvim",
	data = {
		enabled = true,
		setup = function()
			require("ibl").setup({})
		end,
	},
}
