return {
	{
		src = "https://github.com/mfussenegger/nvim-dap",
		data = {
			enabled = true,
			setup = function()
				local dap = require("dap")

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
			end,
			keymaps = {
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
			},
		},
	},
	{
		src = "https://github.com/igorlfs/nvim-dap-view",
		data = {
			enabled = true,
			setup = function()
				require("dap-view").setup({})
			end,
		},
	},
}
