return {
	src = "https://github.com/windwp/nvim-autopairs",
	data = {
		enabled = true,
		setup = function()
			require("nvim-autopairs").setup({})
		end,
	},
}
