local utils = require("utils")

return {
	{
		desc = "Toggle AI chat",
		mode = { "n", "v" },
		keys = "<leader>ta",
		cmd = function()
			utils.launch_terminal({
				cmd = "ollama serve",
				close_after_cmd = true,
			})
			vim.cmd("CodeCompanionChat Toggle")
		end,
	},
	{
		desc = "Open color picker",
		mode = { "n", "v" },
		keys = "<leader>tc",
		cmd = ":CccPick<CR>",
	},
}
