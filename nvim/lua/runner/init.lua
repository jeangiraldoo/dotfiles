local DEFAULTS = require("runner._defaults")
local utils = require("utils")

local OS_NAME = vim.loop.os_uname().sysname

local OS_SHELL_OPERATORS = ({
	Linux = {
		["=>"] = " && ",
		[">>"] = " ; ",
	},
})[OS_NAME]

local CodeRunner = {}

local function _display_warning(msg)
	vim.notify("[Runner] " .. msg, vim.log.levels.WARN)
end

local function _build_cmd(cmd_list, paths, venv)
	local file_name
	if paths.file_absolute then
		file_name = paths.file_absolute:match(".*/(.+)%.%w+$")
	else
		paths.file_absolute = vim.fn.expand("%:p")
		file_name = vim.fn.expand("%:t:r")
	end

	local cmd = table.concat(cmd_list, " && ")

	for key, val in pairs(OS_SHELL_OPERATORS) do
		cmd = cmd:gsub(key, val)
	end

	if paths.root and venv and vim.fn.isdirectory(vim.fs.joinpath(paths.root, venv.marker)) == 1 then
		cmd = (venv.source_command .. " && " .. cmd):gsub("%%root_path", paths.root)
	end

	cmd = cmd:gsub("%%abs_file_path", paths.file_absolute):gsub("%%file_name", file_name)

	return cmd
end

local function _run_file(filetype_data, paths)
	local data = {
		cwd = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
		cmd = _build_cmd(filetype_data.commands.file or filetype_data.commands, paths, filetype_data.venv),
		close_after_cmd = filetype_data.close_after_cmd,
	}

	utils.terminal.launch(data)
end

local function _run_project(filetype_data, paths, project_markers)
	if not paths.root then
		_display_warning("No project root found")
		return
	end

	local terminal_data = {
		cwd = paths.root,
		close_after_cmd = filetype_data.close_after_cmd,
	}

	for _, file_marker in ipairs(project_markers) do
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
end

function CodeRunner.run(data)
	local filetype = vim.bo.filetype
	local filetype_data = DEFAULTS[filetype]

	if filetype_data == nil then
		_display_warning("No settings defined for " .. filetype)
		return
	end

	local repo_markers = filetype_data.markers

	-- Markers are optional for files because a file (e.g., a script) can be standalone or part of a project
	if not data.run_current_file and not repo_markers then
		_display_warning("No project markers defined for " .. filetype)
		return
	end

	local paths = {}

	if repo_markers then
		paths.root = vim.fs.root(0, repo_markers.static) or vim.fs.root(0, repo_markers.code)
	end

	if data.run_current_file then
		_run_file(filetype_data, paths)
		return
	end

	_run_project(filetype_data, paths, repo_markers.code)
end

return CodeRunner
