return function(wezterm)
	local act = wezterm.action
	return {
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
	}
end
