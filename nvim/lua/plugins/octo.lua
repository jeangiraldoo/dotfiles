return {
	src = "https://github.com/pwntester/octo.nvim",
	dependencies = {
		{ src = "https://github.com/nvim-lua/plenary.nvim" },
		{ src = "https://github.com/ibhagwan/fzf-lua" },
		{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	},
	data = {
		enabled = true,
		setup = function()
			require("octo").setup({
				picker = "fzf-lua",
			})
		end,
	},
}
