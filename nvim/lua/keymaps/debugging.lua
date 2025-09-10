return {
	{
		desc = "Toggle debugger UI",
		mode = "n",
		keys = "<leader>dt",
		cmd = function()
			vim.cmd("DapViewToggle")
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>j", true, false, true), "n", true)
		end,
	},
	{
		name = "Start/resume debug session",
		mode = "n",
		keys = "<leader>dc",
		cmd = ":DapContinue<CR>",
	},
	{
		desc = "Toggle debugger breakpoint",
		mode = "n",
		keys = "<leader>db",
		cmd = ":DapToggleBreakpoint<CR>",
	},
	{
		desc = "Step debugger over",
		mode = "n",
		keys = "<leader>dj",
		cmd = ":DapStepOver<CR>",
	},
	{
		desc = "Step debugger into",
		mode = "n",
		keys = "<leader>dl",
		cmd = ":DapStepInto<CR>",
	},
	{
		desc = "Step debugger out",
		mode = "n",
		keys = "<leader>dh",
		cmd = ":DapStepOut<CR>",
	},
}
