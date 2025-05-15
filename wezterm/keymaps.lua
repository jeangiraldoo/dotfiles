local wezterm = require("wezterm")
local act = wezterm.action
local utils = require("utils")

local os_info = wezterm.target_triple

local paths = {
	home = os.getenv(os_info:find("windows") and "USERPROFILE" or "HOME"),
	nvim_data = utils.get_os_data("env_var", {
		name = "nvim_data",
	}),
}

local shell_exec = utils.get_os_data("shell", {
	mode = false,
})

return utils.flatten_tbls({
	workspaces = (function()
		local templates = {
			{
				name = "dotfiles",
				cwd = paths.home .. "/.config",
			},
			{
				name = "Programming dir",
				cwd = paths.home .. "/documents/programming/",
			},
			{
				name = "Codedocs",
				cwd = paths.nvim_data .. "/nvim-data/lazy/codedocs.nvim/lua/codedocs/",
				args = utils.flatten_tbls({
					shell_exec,
					{ "git status; ls" },
				}),
			},
		}

		local ws_keys = {}
		for i, curr_ws in pairs(templates) do
			table.insert(ws_keys, {
				key = tostring(i),
				mods = "ALT",
				action = act.SwitchToWorkspace({
					name = curr_ws.name,
					spawn = {
						cwd = curr_ws.cwd,
						args = curr_ws.args,
					},
				}),
			})
		end
		return ws_keys
	end)(),
	window_mgmt = {
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
				args = { "nvim", paths.home .. "/.wezterm.lua" },
			}),
		},
	},
	tab_nav = (function()
		local keys = {}
		for i = 0, 9 do
			table.insert(keys, {
				key = (i < 9) and tostring(i + 1) or "0",
				mods = "CTRL",
				action = wezterm.action.ActivateTab(i),
			})
		end
		return keys
	end)(),
})
