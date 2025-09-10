return {
	{
		name = "nvim-dap",
		author = "mfussenegger",
		remove_name_suffix = true,
		dependencies = {
			{
				name = "nvim-web-devicons",
				author = "nvim-tree",
				remove_name_suffix = true,
				require_name = "nvim-web-devicons",
			},
		},
		config = function()
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
	},
	{
		name = "nvim-dap-view",
		author = "igorlfs",
		remove_name_suffix = true,
		require_name = "dap-view",
	},
}
