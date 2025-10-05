local DEFAULTS = require("custom.runner._defaults")
local utils = require("utils")

local CodeRunner = {}

local function _display_warning(msg)
	vim.notify("[Runner] " .. msg, vim.log.levels.WARN)
end

local function _build_cmd(cmd_list, abs_file_path)
	local file_name
	if abs_file_path then
		file_name = abs_file_path:match(".*/(.+)%.%w+$")
	else
		abs_file_path = vim.fn.expand("%:p")
		file_name = vim.fn.expand("%:t:r")
	end

	local cmd = table.concat(cmd_list, " && "):gsub("%%abs_file_path", abs_file_path):gsub("%%file_name", file_name)
	return cmd
end

local function _run_file(filetype_data)
	local data = {
		cwd = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
		cmd = _build_cmd(filetype_data.commands),
		close_after_cmd = filetype_data.close_after_cmd,
	}

	utils.launch_terminal(data)
end

local function _run_project(filetype_data)
	local project_markers = filetype_data.markers

	if not project_markers then
		_display_warning("No project markers defined for " .. vim.bo.filetype)
		return
	end

	local project_root_path = vim.fs.root(0, project_markers)

	if not project_root_path then
		_display_warning("No project root found")
		return
	end

	local terminal_data = {
		cwd = project_root_path,
		close_after_cmd = filetype_data.close_after_cmd,
	}

	for _, file_marker in ipairs(project_markers) do
		local marker_path = vim.fs.joinpath(project_root_path, file_marker)

		if vim.uv.fs_stat(marker_path) then
			terminal_data.cmd = _build_cmd(filetype_data.commands, marker_path)

			utils.launch_terminal(terminal_data)
			return
		end
	end
end

function CodeRunner.run(data)
	local filetype = vim.bo.filetype
	local filetype_data = DEFAULTS[filetype]

	if filetype_data == nil then
		_display_warning("No settings defined for " .. filetype)
		return
	end

	if data.run_current_file then
		_run_file(filetype_data.file)
		return
	end

	_run_project(filetype_data.project)
end

return CodeRunner
