local DEFAULTS = require("runner._defaults")
local utils = require("utils")

local Runner = {}

local function _display_warning(msg)
	vim.notify("[Runner] " .. msg, vim.log.levels.WARN)
end

local function _build_cmd(cmd_list, paths, venv)
	local file_name = vim.fn.fnamemodify(paths.file_absolute, ":t:r")

	local cmd = table.concat(cmd_list, " && ")

	if venv and vim.fn.isdirectory(vim.fs.joinpath(paths.root, venv.marker)) == 1 then
		cmd = (venv.source_command .. " && " .. cmd):gsub("%%root_path", paths.root)
	end

	return cmd:gsub("%%abs_file_path", paths.file_absolute):gsub("%%file_name", file_name)
end

local function _retrieve_filetype_data()
	local filetype = vim.bo.filetype
	local filetype_data = DEFAULTS[filetype]

	if filetype_data == nil then
		_display_warning("No settings defined for " .. filetype)
	end

	return filetype_data
end

local function _get_paths(repo_markers)
	local paths = {}

	if repo_markers then
		paths.root = vim.fs.root(0, repo_markers.static) or vim.fs.root(0, repo_markers.code)
	end

	return paths
end

local RUNNERS = {
	{
		label = "File",
		run = function()
			local filetype_data = _retrieve_filetype_data()
			if not filetype_data then
				return
			end

			local paths = _get_paths(filetype_data.markers)
			paths.file_absolute = vim.fn.expand("%:p")

			utils.terminal.launch({
				cwd = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
				cmd = _build_cmd(filetype_data.commands.file or filetype_data.commands, paths, filetype_data.venv),
				close_after_cmd = filetype_data.close_after_cmd,
			})
		end,
	},
	{
		label = "Project",
		run = function()
			local filetype_data = _retrieve_filetype_data()
			if not filetype_data then
				return
			end

			if not filetype_data.markers then
				_display_warning("No project markers defined for " .. vim.bo.filetype)
				return
			end

			local paths = _get_paths(filetype_data.markers)

			if not paths.root then
				_display_warning("No project root found")
				return
			end

			local terminal_data = {
				cwd = paths.root,
				close_after_cmd = filetype_data.close_after_cmd,
			}

			for _, file_marker in ipairs(filetype_data.markers.code) do
				local code_marker_path = vim.fs.joinpath(paths.root, file_marker)

				if vim.uv.fs_stat(code_marker_path) then
					paths["file_absolute"] = code_marker_path
					terminal_data.cmd =
						_build_cmd(filetype_data.commands.project or filetype_data.commands, paths, filetype_data.venv)

					utils.terminal.launch(terminal_data)
					return
				end
			end
			_display_warning("No code marker found")
		end,
	},
	{ --- Displays a project-specific command menu offering a predefined list of actions
		--- Commands may be defined from any source, such as a `.nvim.lua` file
		label = "Project-specific Commands",
		run = function()
			vim.ui.select(DEFAULTS.project_commands, {
				prompt = "Select command:",
			}, function(item)
				if item then
					utils.terminal.launch({
						cwd = vim.fs.root(0, { ".git" }) or vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
						cmd = item,
					})
				end
			end)
		end,
	},
}

function Runner.display_menu()
	vim.ui.select(RUNNERS, {
		prompt = "Select runner:",
		format_item = function(item)
			return item.label
		end,
	}, function(item)
		if item then
			item.run()
		end
	end)
end

return Runner
