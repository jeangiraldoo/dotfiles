return function(wezterm)
	local keys = {}
	for i = 0, 9 do
		table.insert(keys, {
			key = (i < 9) and tostring(i + 1) or "0",
			mods = "CTRL",
			action = wezterm.action.ActivateTab(i),
		})
	end
	return keys
end
