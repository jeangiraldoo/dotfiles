local wezterm = require("wezterm")
local utils = {}

local specs = {
	windows = {
		env_vars = {
			home = "USERPROFILE",
			nvim_data = "LOCALAPPDATA",
		},
		shell = {
			base = {
				"powershell.exe",
				"-nologo",
			},
			cmd_exec = {
				"powershell.exe",
				"-NoExit",
				"-Command",
			},
		},
	},
	linux = {
		env_vars = {
			home = "HOME",
			nvim_data = "XDG_DATA_HOME",
		},
		shell = {},
	},
}

function utils.flatten_tbls(tbls)
	local final_tbl = {}
	for _, tbl in pairs(tbls) do
		for _, subtbl in pairs(tbl) do
			table.insert(final_tbl, subtbl)
		end
	end
	return final_tbl
end

function utils.get_os_data(data_type, context)
	local data_types = {
		shell = function(data)
			return data.context.mode and data.shell.base or data.shell.cmd_exec
		end,
		env_var = function(data)
			return string.gsub(os.getenv(data.env_vars[data.context.name]), "\\", "/")
		end,
	}
	local os_info = wezterm.target_triple
	for os_name, spec in pairs(specs) do
		if os_info:find(os_name) then
			return data_types[data_type]({
				env_vars = spec.env_vars,
				shell = spec.shell,
				context = context,
			})
		end
	end
end

return utils
