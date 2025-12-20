local DEFAULTS = require("runner._defaults")
local utils = require("utils")

local Runner = {}

--- Considered to apply to all projects
local PROJECT_STATIC_MARKERS = {
	".git",
	".hg",
	".svn",
	".bzr",
}

for _, data in pairs(DEFAULTS) do
	if data.project and data.project.markers and data.project.markers.static then
		data.project.markers.static = vim.list_extend(vim.deepcopy(PROJECT_STATIC_MARKERS), data.project.markers.static)
	end
end

local function _display_warning(msg)
	vim.notify("[Runner] " .. msg, vim.log.levels.WARN)
end

local function build_venv_cmd(root, venv_options, source_command)
	for _, venv_name in ipairs(venv_options) do
		if vim.fn.isdirectory(vim.fs.joinpath(root, venv_name)) == 1 then
			return (source_command .. " && "):gsub("%%root_path", root):gsub("%%venv_marker", venv_name)
		end
	end

	return ""
end

local function _build_cmd(cmd_list, paths, venv, executable)
	local file_name = vim.fn.fnamemodify(paths.file_absolute, ":t:r")
	local cmd = table.concat(cmd_list, " && ")

	if venv then
		cmd = build_venv_cmd(paths.root, venv.markers, venv.source_command) .. cmd
	end

	local executable_cmd = type(executable) == "table" and executable[vim.loop.os_uname().sysname] or executable
	return cmd:gsub("%%abs_file_path", paths.file_absolute)
		:gsub("%%file_name", file_name)
		:gsub("%%executable", executable_cmd)
end

local function _retrieve_filetype_data()
	local filetype = vim.bo.filetype
	local filetype_data = DEFAULTS[filetype]

	if filetype_data == nil then
		_display_warning("No settings defined for " .. filetype)
	end

	return filetype_data
end

local RUNNERS = {
	{
		label = "File",
		run = function()
			local filetype_data = _retrieve_filetype_data()
			if not filetype_data then
				return
			end

			local commands = filetype_data.commands or (filetype_data.file and filetype_data.file.commands)
			if not commands then
				_display_warning("No file commands defined for " .. vim.bo.filetype_data)
				return
			end

			local paths = {
				root = vim.fn.expand("%:p:h"),
				file_absolute = vim.fn.expand("%:p"),
			}

			utils.terminal.launch({
				cwd = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
				cmd = _build_cmd(commands, paths, filetype_data.venv, filetype_data.executable),
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

			if not filetype_data.project then
				_display_warning("No project section defined for " .. vim.bo.filetype)
				return
			end

			local commands = filetype_data.commands or filetype_data.project.commands
			if not commands then
				_display_warning("No project commands defined for " .. vim.bo.filetype)
				return
			end

			local paths = {
				root = vim.fs.root(0, filetype_data.project.markers.static)
					or vim.fs.root(0, filetype_data.project.markers.code),
			}

			if not paths.root then
				_display_warning("No project root found")
				return
			end

			local terminal_data = {
				cwd = paths.root,
				close_after_cmd = filetype_data.close_after_cmd,
			}

			for _, file_marker in ipairs(filetype_data.project.markers.code) do
				local code_marker_path = vim.fs.joinpath(paths.root, file_marker)

				if vim.uv.fs_stat(code_marker_path) then
					paths["file_absolute"] = code_marker_path
					terminal_data.cmd = _build_cmd(commands, paths, filetype_data.venv, filetype_data.executable)

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
