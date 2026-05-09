vim.pack.add {
	{
		src = "https://github.com/mfussenegger/nvim-dap",
	},
	{
		src = "https://github.com/igorlfs/nvim-dap-view",
	},
}

local dap = require "dap"
require("dap-view").setup {}

dap.adapters.python = {
	type = "executable",
	command = "python3",
	args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
	{
		type = "python",
		request = "launch",
		name = "Launch current file",
		program = "${file}",
		pythonPath = "python3",
	},
}
vim.defer_fn(function()
	vim.api.nvim_set_hl(0, "DapBreakpoint", {
		fg = "#FF0000",
	})
	vim.api.nvim_set_hl(0, "DapStopped", {
		fg = "#00add6",
	})
end, 50)

vim.fn.sign_define("DapBreakpoint", {
	text = "●",
	texthl = "DapBreakpoint",
	linehl = "",
	numhl = "",
})

vim.fn.sign_define("DapStopped", {
	text = "",
	texthl = "DapStopped",
})

vim.keymap.set("n", "<leader>dt", function()
	vim.cmd "DapViewToggle"
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>j", true, false, true), "n", true)
end, { desc = "Toggle debugger UI", silent = true })
vim.keymap.set("n", "<leader>dc", ":DapContinue<CR>", { desc = "Start/resume debug session", silent = true })
vim.keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>", { desc = "Toggle debugger breakpoint", silent = true })
vim.keymap.set("n", "<leader>dj", ":DapStepOver<CR>", { desc = "Step debugger over", silent = true })
vim.keymap.set("n", "<leader>dl", ":DapStepInto<CR>", { desc = "Step debugger into", silent = true })
vim.keymap.set("n", "<leader>dh", ":DapStepOut<CR>", { desc = "Step debugger out", silent = true })
