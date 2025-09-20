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
		}
	},
	{
		src = "https://github.com/igorlfs/nvim-dap-view",
		data = {
			enabled = true,
			setup = function()
				require("dap-view").setup({})
			end
		}
	},
}
