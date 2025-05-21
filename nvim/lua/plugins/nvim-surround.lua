return {
	"kylechui/nvim-surround",
	version = "*",
	event = "VeryLazy",
	config = function()
		require("nvim-surround").setup({
			keymaps = {
				normal = "<leader>ls",
				visual = "<leader>ls",
				change = "<leader>rs",
			},
		})
	end,
}
