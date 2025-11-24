local Utils = {
	module = {},
	editor = {},
	terminal = {},
}

local function _is_valid_lua_file(file_name)
	local is_lua = file_name:sub(-4) == ".lua"
	local is_init = file_name == "init.lua"
	return is_lua and not is_init
end

function Utils.module.fetch_join_tables(dir)
	local full_path = vim.fn.stdpath("config") .. "/lua/" .. dir:gsub("%.", "/")
	local dir_files = vim.fn.readdir(full_path)

	local combined_entries = vim.iter(dir_files)
		:filter(function(file_name)
			return _is_valid_lua_file(file_name)
		end)
		:fold({}, function(acc, file_name)
			local file_relative_path = dir .. "." .. file_name:gsub("%.lua$", "")

			local ok, file_tbl = pcall(require, file_relative_path)
			if not ok then
				vim.notify("Failed to load " .. file_relative_path, vim.log.levels.WARN)
				return acc
			end

			if vim.islist(file_tbl) then
				return vim.list_extend(acc, file_tbl)
			end

			table.insert(acc, file_tbl)
			return acc
		end)

	return combined_entries
end

function Utils.editor.set_keymaps(keymaps)
	local DEFAULT_OPTS = {
		noremap = true,
		silent = true,
	}

	for _, keymap in ipairs(keymaps) do
		local opts = vim.tbl_extend("force", DEFAULT_OPTS, keymap.opts or {})

		if keymap.desc then
			opts.desc = keymap.desc
		end

		vim.keymap.set(keymap.mode, keymap.keys, keymap.cmd, opts)
	end
end

--- Launches a configurable terminal using a vertical split.
--- @param opts table A table with the following optional settings:
--- * `cmd`: The shell command to run.
--- * `close_after_cmd`: Whether or not to close the terminal after running a command.
---   Mimicks running a command in the background.
--- * `cwd`: The working directory to run the command from.
--- @return nil
function Utils.terminal.launch(opts)
	print("hi there")
	opts = opts or {}

	if opts.close_after_cmd and not opts.cmd then
		return
	end

	if opts.close_after_cmd then
		vim.fn.jobstart(opts.cmd)
		return
	end

	vim.cmd("botright new")
	vim.cmd.term()
	local job_id = vim.bo.channel

	-- If opts.cmd is nil, chansend() sends nothing and the shell starts interactively
	local interactive_terminal_cmd = opts.cmd and opts.cmd .. "\r\n"
	vim.fn.chansend(job_id, { interactive_terminal_cmd })
end

return Utils
