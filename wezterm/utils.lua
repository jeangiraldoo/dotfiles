local wezterm = require("wezterm")

local utils = {}

utils.SYSTEM = {
	OS_NAME = (package.config:sub(1, 1) == "\\") and "windows" or "linux",
	HOME = os.getenv("HOME") or (os.getenv("USERPROFILE"):gsub("\\", "/")),
}

function utils.create_project_workspace(window, pane, project_type)
	local projects_list = utils.scandir({
		path = utils.get_path("projects") .. "/" .. project_type,
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
				else
					wezterm.log_info("you selected ", id, label)
					window:perform_action(
						wezterm.action.SwitchToWorkspace({
							name = label,
							spawn = {
								cwd = id,
							},
						}),
						pane
					)
				end
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

function utils.flatten_tbls(tbls)
	local final_tbl = {}
	for _, tbl in pairs(tbls) do
		for _, subtbl in pairs(tbl) do
			table.insert(final_tbl, subtbl)
		end
	end
	return final_tbl
end

function utils.list_extend(t1, t2)
	for _, v in ipairs(t2) do
		table.insert(t1, v)
	end
	return t1
end

function utils.get_path(path_name)
	local paths = {
		config = ".config",
		projects = ".code",
	}
	local chosen_path = paths[path_name]
	local path_ending = chosen_path == nil and path_name or chosen_path

	local final_path = utils.SYSTEM.HOME .. "/" .. path_ending
	return final_path
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

function utils.get_combined_module_tables(dir, args)
	local config_path = utils.get_path("config")
	local full_path = config_path .. "/wezterm/" .. dir:gsub("%.", "/")

	local dir_files = utils.scandir({ path = full_path }, true)
	local combined_entries = {}

	for _, file_name in ipairs(dir_files) do
		if file_name:match("%.lua$") and not file_name:match("^init%.lua$") then
			local file_relative_path = dir .. "." .. file_name:gsub("%.lua$", "")
			local ok, file_tbl = pcall(require, file_relative_path)

			local data_to_extend = {
				table = function()
					return file_tbl
				end,
				["function"] = function()
					return file_tbl(table.unpack(args))
				end,
			}

			if ok then
				utils.list_extend(combined_entries, data_to_extend[type(file_tbl)]())
			else
				io.stderr:write("Warning: Unexpected return type from " .. file_relative_path .. "\n")
			end
		end
	end

	return combined_entries
end

return utils
