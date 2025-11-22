local wezterm = require("wezterm")

local utils = {}

utils.SYSTEM = {
	OS_NAME = (package.config:sub(1, 1) == "\\") and "windows" or "linux",
	HOME = os.getenv("HOME") or (os.getenv("USERPROFILE"):gsub("\\", "/")),
}

utils.SYSTEM.PATHS = {
	PROJECTS = utils.SYSTEM.HOME .. "/.code",
	CONFIG = utils.SYSTEM.HOME .. "/.config",
}

function utils.create_project_workspace(window, pane, project_type)
	local projects_list = utils.scandir({
		path = utils.SYSTEM.PATHS.PROJECTS .. "/" .. project_type,
		fn = function(opts)
			local entry = wezterm.format({
				{ Attribute = { Underline = "None" } },
				{ Attribute = { Italic = true } },
				{ Foreground = { AnsiColor = "Navy" } },
				{ Text = opts.ln },
			})
			table.insert(opts.result, { label = entry, id = opts.path .. "/" .. opts.ln })
		end,
	}, false)

	window:perform_action(
		wezterm.action.InputSelector({
			action = wezterm.action_callback(function(window, pane, id, label)
				if not id and not label then
					wezterm.log_info("cancelled")
					return
				end

				wezterm.log_info("you selected ", id, label)

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
				{ Text = project_type },
				"ResetAttributes",
				{ Foreground = { AnsiColor = "Green" } },
				{ Text = "プロジェクトを選ぶ\n" },
			}),
		}),
		pane
	)
end

function utils.scandir(opts, get_files)
	local fn = opts.fn or function(vals)
		table.insert(vals.result, vals.ln)
	end

	local cmd
	if utils.SYSTEM.OS_NAME == "windows" then
		local cmd_ending = get_files and '" /b /a:-d 2>nul' or '" /b /a:d 2>nul'
		cmd = 'dir "' .. opts.path .. cmd_ending
	end
	local handle = io.popen(cmd)

	if not handle then
		return {}
	end

	local result = {}
	for line in handle:lines() do
		fn({
			result = result,
			ln = line,
			path = opts.path,
		})
	end

	handle:close()
	return result
end

return utils
