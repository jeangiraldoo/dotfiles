return function(wezterm)
	local act = wezterm.action
	return {
		{
			key = "f",
			mods = "CTRL",
			action = act.Multiple({
				act.SendString("yazi"),
				act.SendKey({ key = "Enter" }),
			}),
		},
		{
			key = "g",
			mods = "CTRL",
			action = act.Multiple({
				act.SendString("lazygit"),
				act.SendKey({ key = "Enter" }),
			}),
		},
	}
end
