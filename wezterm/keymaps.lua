local wezterm = require("wezterm")
local act = wezterm.action
local utils = require("utils")

local keymaps = {
	-- Window management
	{
		key = "T",
		mods = "CTRL",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "t",
		mods = "CTRL",
		action = act.SplitPane({
			direction = "Right",
		}),
	},
	{
		key = "q",
		mods = "CTRL",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "Q",
		mods = "CTRL",
		action = act.CloseCurrentTab({ confirm = true }),
	},
	{
		key = "l",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "h",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Left"),
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

-- Tab management
for i = 0, 9 do
	table.insert(keymaps, {
		key = (i < 9) and tostring(i + 1) or "0",
		mods = "CTRL",
		action = wezterm.action.ActivateTab(i),
	})
end

return keymaps
