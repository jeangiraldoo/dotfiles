return function(wezterm, utils)
	local act = wezterm.action
	return {
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
end
