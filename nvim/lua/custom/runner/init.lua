local utils = require("utils")
local DEFAULTS = require("custom.runner._defaults")

local CodeRunner = {}

local function _display_warning(msg)
	vim.notify("[Runner] " .. msg, vim.log.levels.WARN)
end

local function _get_filetype_data()
	local filetype = vim.bo.filetype
	local filetype_data = DEFAULTS[filetype]

	if not filetype_data then
		_display_warning("Unsupported filetype: " .. filetype)
		return
	end

	return filetype_data
end

local function _run_file(filetype_data)
	local file_path = vim.fn.expand("%:p")

	local data = {
		cmd = string.format(filetype_data.cmd, file_path),
		cwd = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
	}

	utils.launch_terminal(data)
end

local function _run_project(filetype_data)
	local project_markers = filetype_data.project_markers
	local project_root_path = vim.fs.root(0, project_markers)

	if not project_root_path then
		_display_warning("No project root found")
		return
	end

	local is_filetype_compiled = filetype_data.type == "compiled"

	for _, file_marker in ipairs(project_markers) do
		local marker_path = project_root_path .. "/" .. file_marker
		if vim.uv.fs_stat(marker_path) then
			local filetype_cmd = filetype_data.cmd
			local cmd = is_filetype_compiled and filetype_cmd or string.format(filetype_cmd, marker_path)

			utils.launch_terminal({
				cmd = cmd,
				cwd = project_root_path,
			})
			return
		end
	end
end

function CodeRunner.run(run_file_as_project)
	local filetype_data = _get_filetype_data()
	if filetype_data == nil then
		return
	end

	if not run_file_as_project and filetype_data.type == "compiled" then
		_display_warning("Compiled languages should be run as a project")
		return
	end

	if not run_file_as_project then
		_run_file(filetype_data)
		return
	end

	_run_project(filetype_data)
end

return CodeRunner
