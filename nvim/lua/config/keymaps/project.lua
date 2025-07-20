local utils = require("utils")

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
		desc = "Run Cloc on project root",
		mode = "n",
		keys = "<leader>tt",
		cmd = function()
			local path, output_lines = utils.run_in_project_root("cloc")
			local project_name = vim.fn.fnamemodify(path, ":t")
			print("Project:", project_name, "\n", output_lines)
		end,
	},
}
