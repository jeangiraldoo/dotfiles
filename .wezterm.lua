local wezterm = require("wezterm")
local act = wezterm.action
local config = {
	colors = {},
}
local utils = {}

-- General setup
config.color_scheme = "Atelierlakeside (dark) (terminal.sexy)"
config.leader = {
	key = "Space",
	mods = "CTRL",
	timeout_milliseconds = 1000,
}

-- Window style
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.8
config.window_frame = {
	font = wezterm.font({ family = "Monocraft" }),
	font_size = 11,
}

-- Tab bar style
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.colors.tab_bar = {
	inactive_tab_edge = "red",
	background = "rgb(0, 0, 5, 0.1)",
}

-- Cursor style
config.default_cursor_style = "BlinkingBar"
config.cursor_thickness = "300%"
config.colors.cursor_bg = "purple"

-- General font style
config.font_dirs = { "fonts" }
config.font_size = 13
config.font = wezterm.font_with_fallback({
	"Monocraft",
})

-- Operating system specs
local windows = {
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
}

local linux = {
	env_vars = {
		home = "HOME",
		nvim_data = "XDG_DATA_HOME",
	},
	shell = {},
}

local specs = {
	windows = windows,
	linux = linux,
}

-- Config utils implementations
local function get_shell_info(data)
	if data.context.mode then
		return data.shell.base
	end
	return data.shell.cmd_exec
end

local function get_env_var_path(data)
	local name = data.context.name
	local raw_path = os.getenv(data.env_vars[name])
	local cross_platform_path = string.gsub(raw_path, "\\", "/")
	return cross_platform_path
end

function utils.get_os_data(data_type, context)
	local data_types = {
		env_var = get_env_var_path,
		shell = get_shell_info,
	}
	local os_info = wezterm.target_triple
	for os_id, spec in pairs(specs) do
		if os_info:find(os_id) then
			return data_types[data_type]({
				env_vars = spec.env_vars,
				shell = spec.shell,
				context = context,
			})
		end
	end
end

function utils.flatten_tbls(tbls)
	local final_tbl = {}
	for _, tbl in pairs(tbls) do
		for _, subtbl in pairs(tbl) do
			table.insert(final_tbl, subtbl)
		end
	end
	return final_tbl
end

config.default_prog = utils.get_os_data("shell", {
	mode = true,
})

-- Keybindings
local home_path = utils.get_os_data("env_var", {
	name = "home",
})
local shell_exec = utils.get_os_data("shell", {
	mode = false,
})
local nvim_data = utils.get_os_data("env_var", {
	name = "nvim_data",
})

local ws_templates = {
	{
		name = "dotfiles",
		cwd = home_path .. "/.config",
	},
	{
		name = "Programming dir",
		cwd = home_path .. "/documents/programming/",
	},
	{
		name = "Codedocs",
		cwd = nvim_data .. "/nvim-data/lazy/codedocs.nvim/lua/codedocs/",
		args = utils.flatten_tbls({
			shell_exec,
			{ "git status; ls" },
		}),
	},
}

local workspaces = (function()
	local ws_keys = {}
	for i = 1, #ws_templates do
		local curr_ws = ws_templates[i]
		local ws_key = {
			key = tostring(i),
			mods = "ALT",
			action = act.SwitchToWorkspace({
				name = curr_ws.name,
				spawn = {
					cwd = curr_ws.cwd,
					args = curr_ws.args,
				},
			}),
		}
		table.insert(ws_keys, ws_key)
	end
	return ws_keys
end)()

local window_mgmt = {
	{
		key = "t",
		mods = "CTRL",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "w",
		mods = "CTRL",
		action = wezterm.action.CloseCurrentTab({ confirm = true }),
	},
	{
		key = ".",
		mods = "CTRL",
		action = wezterm.action.SpawnCommandInNewTab({
			args = { "nvim", home_path .. "/.wezterm.lua" },
		}),
	},
}

local tab_nav = (function()
	local keys = {}
	for i = 1, 9 do
		local key = {
			key = tostring(i),
			mods = "CTRL",
			action = wezterm.action.ActivateTab(i - 1),
		}
		table.insert(keys, key)
	end
	local key_0 = {
		key = "0",
		mods = "CTRL",
		action = wezterm.action.ActivateTab(9),
	}
	table.insert(keys, key_0)
	return keys
end)()

config.keys = utils.flatten_tbls({
	workspaces,
	tab_nav,
	window_mgmt,
})

return config
