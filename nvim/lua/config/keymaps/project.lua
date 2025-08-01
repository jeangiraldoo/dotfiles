local utils = require("utils")
local code_runner = require("custom.code_runner")

return {
	{
		desc = "Record actions",
		mode = "n",
		keys = "<leader>z",
		cmd = function()
			local is_recording = vim.fn.reg_recording() ~= ""
			if is_recording then
				vim.api.nvim_feedkeys("q", "n", false)
			else
				vim.api.nvim_feedkeys("qq", "n", false)
			end
		end,
	},
	{
		desc = "Display file tree",
		mode = "n",
		keys = "<leader>pt",
		cmd = ":Neotree right toggle<CR>",
	},
	{
		desc = "Run file",
		mode = "n",
		keys = "<leader>lf",
		cmd = function()
			code_runner.run_file()
		end,
	},
	{
		desc = "Run project",
		mode = "n",
		keys = "<leader>lp",
		cmd = function()
			code_runner.run_project()
		end,
	},
	{
		desc = "Launch terminal",
		mode = "n",
		keys = "<leader>tt",
		cmd = function()
			utils.launch_terminal()
		end,
	},
}
