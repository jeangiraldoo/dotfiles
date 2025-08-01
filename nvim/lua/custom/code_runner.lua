local utils = require("utils")

local CodeRunner = {}

local CMDS = {
	python = {
		type = "interpreted",
		cmd = "python %s",
		project_markers = {
			"main.py",
		},
	},
	javascript = {
		type = "interpreted",
		cmd = "node %s",
		project_markers = {
			"index.js",
			"main.js",
		},
	},
	go = {
		type = "compiled",
		cmd = "go run .",
		project_markers = {
			"go.mod",
			"main.go",
		},
	},
	rust = {
		type = "compiled",
		cmd = "cargo run",
		project_markers = {
			"Cargo.toml",
		},
	},
}

local function notify(msg)
	vim.notify("[CodeRunner] " .. msg, vim.log.levels.WARN)
end

local function _get_filetype_data()
	local filetype = vim.bo.filetype
	local filetype_data = CMDS[filetype]

	if not filetype_data then
		notify("Unsupported filetype: " .. filetype)
		return
	end

	return filetype_data
end

function CodeRunner.run_file()
	local file_path = vim.fn.expand("%:p")

	local filetype_data = _get_filetype_data()
	if filetype_data == nil then
		return
	end

	local data = {
		cmd = string.format(filetype_data.cmd, file_path),
		cwd = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
	}

	utils.launch_terminal(data)
end

function CodeRunner.run_project()
	local filetype_data = _get_filetype_data()
	if filetype_data == nil then
		return
	end
	local project_markers = filetype_data.project_markers
	local project_root_path = vim.fs.root(0, project_markers)

	if not project_root_path then
		notify("No project root found")
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

return CodeRunner
