local wezterm = require("wezterm")
local act = wezterm.action
local utils = require("utils")

-- Window transparency settings
local OPACITY = {
	TRANSPARENT = 0.8,
	OPAQUE = 1,
}
local is_window_transparent = true

local keymaps = {
	-- Window management
	{
		key = "q",
		mods = "CTRL",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "z",
		mods = "CTRL",
		action = wezterm.action_callback(function(window, _) -- Toggle transparency
			is_window_transparent = not is_window_transparent

			local overrides = window:get_config_overrides() or {}
			overrides.window_background_opacity = is_window_transparent and OPACITY.OPAQUE or OPACITY.TRANSPARENT
			window:set_config_overrides(overrides)
		end),
	},
	-- Workspaces
	{
		key = ".",
		mods = "ALT",
		action = act.SwitchToWorkspace({
			name = "Configs",
			spawn = {
				cwd = utils.get_path("config"),
			},
		}),
	},
	{
		key = "1",
		mods = "ALT",
		action = wezterm.action_callback(function(window, pane)
			utils.create_project_workspace(window, pane, "personal")
		end),
	},
	{
		key = "2",
		mods = "ALT",
		action = wezterm.action_callback(function(window, pane)
			utils.create_project_workspace(window, pane, "university")
		end),
	},
}

return keymaps
