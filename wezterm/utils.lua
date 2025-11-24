local wezterm = require("wezterm")

local utils = {
	SYSTEM = {},
}

if package.config:sub(1, 1) == "\\" then
	utils.SYSTEM.OS_NAME = "windows"
	utils.SYSTEM.DEFAULT_PROGRAM = "wsl"
	utils.SYSTEM.HOME = os.getenv("USERPROFILE"):gsub("\\", "/")
else
	utils.SYSTEM.OS_NAME = "linux"
	utils.SYSTEM.DEFAULT_PROGRAM = "bash"
	utils.SYSTEM.HOME = os.getenv("HOME")
end

utils.SYSTEM.PATHS = {
	PROJECTS = utils.SYSTEM.HOME .. "/.code",
	CONFIG = utils.SYSTEM.HOME .. "/.config",
}

function utils.create_project_workspace(window, pane, projects_path)
	local projects_dirs_paths = utils.get_subdirs(projects_path)

	local projects_list = {}
	for _, path in ipairs(projects_dirs_paths) do
		local dir_name = path:match("([^/]+)$")

		local input_entry_line = wezterm.format({
			{ Attribute = { Underline = "None" } },
			{ Attribute = { Italic = true } },
			{ Foreground = { AnsiColor = "Navy" } },
			{ Text = dir_name },
		})
		table.insert(projects_list, { label = input_entry_line, id = path })
	end

	window:perform_action(
		wezterm.action.InputSelector({
			action = wezterm.action_callback(function(window, pane, id, label)
				local item_was_selected = id or label

				if not item_was_selected then
					wezterm.log_info("Cancelled input selection")
					return
				end

				wezterm.log_info("You selected ", id, label)

				window:perform_action(
					wezterm.action.SwitchToWorkspace({
						name = label,
						spawn = {
							cwd = id,
							args = {
								os.getenv("EDITOR") or "nvim",
							},
						},
					}),
					pane
				)

				window:perform_action(
					wezterm.action.SpawnCommandInNewTab({
						cwd = id,
						args = { "lazygit" },
					}),
					pane
				)
				window:perform_action(wezterm.action.ActivateTab(0), pane)
			end),
			choices = projects_list,
			alphabet = "〇一二三四五六七八九十",
			description = wezterm.format({
				{ Foreground = { AnsiColor = "Purple" } },
				{ Text = "  ᛯ " },
				{ Foreground = { AnsiColor = "Green" } },
				"ResetAttributes",
				{ Foreground = { AnsiColor = "Red" } },
				{ Attribute = { Intensity = "Bold" } },
				{ Attribute = { Underline = "Single" } },
				{ Text = projects_path },
				"ResetAttributes",
				{ Foreground = { AnsiColor = "Green" } },
				{ Text = "プロジェクトを選ぶ\n" },
			}),
		}),
		pane
	)
end

function utils.get_subdirs(dir_path)
	local dir_items = wezterm.read_dir(dir_path)

	local dirs = {}
	for _, item_path in ipairs(dir_items) do
		local normalized_item_path = item_path:gsub("%\\", "/")

		local item_is_dir, _ = pcall(wezterm.read_dir, normalized_item_path)
		if item_is_dir then
			table.insert(dirs, normalized_item_path)
		end
	end
	return dirs
end

return utils
