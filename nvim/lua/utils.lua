local Utils = {
	module = {},
	editor = {},
	terminal = {},
}

---@param dir_name string
---@return table[] acc Merged directory tables
function Utils.module.require_config_tables(dir_name)
	local full_path = vim.fs.joinpath(vim.fn.stdpath("config"), "lua", dir_name)
	local dir_files = vim.fn.readdir(full_path, [[v:val =~ '\.lua$' && v:val !=# 'init.lua']])

	return vim.iter(dir_files):fold({}, function(acc, file_name)
		local lua_file_path = dir_name .. "." .. file_name:gsub("%.lua$", "")

		local ok, file_tbl = pcall(require, lua_file_path)
		if not ok then
			vim.notify("Failed to load " .. lua_file_path, vim.log.levels.WARN)
			return acc
		end

		if vim.islist(file_tbl) then
			return vim.list_extend(acc, file_tbl)
		end

		table.insert(acc, file_tbl)
		return acc
	end)
end

function Utils.editor.set_highlights(highlights)
	for highlight_name, data in pairs(highlights) do
		vim.api.nvim_set_hl(0, highlight_name, data)
	end
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

--- @param title string | nil Window title
--- @return fun(): { buffer_id: number | nil, window_id: number | nil} window_toggler
function Utils.editor.build_window_toggler(title)
	local current_state = {
		buffer_id = vim.api.nvim_create_buf(true, true),
		window_id = nil,
	}

	local window_toggler = function()
		current_state.buffer_id = vim.api.nvim_buf_is_valid(current_state.buffer_id) and current_state.buffer_id
			or vim.api.nvim_create_buf(true, true)

		if current_state.window_id and vim.api.nvim_win_is_valid(current_state.window_id) then
			vim.api.nvim_win_close(current_state.window_id, true)
			current_state.window_id = nil
			return current_state
		end

		local WINDOW = {
			HEIGHT = 22,
			WIDTH = 105,
			VERTICAL_MIDDLE_POS = math.floor(vim.api.nvim_win_get_height(0) / 2),
			HORIZONTAL_MIDDLE_POS = math.floor(vim.api.nvim_win_get_width(0) / 2),
		}

		WINDOW.HALF_HEIGHT = math.floor(WINDOW.HEIGHT / 2)
		WINDOW.HALF_WIDTH = math.floor(WINDOW.WIDTH / 2)

		current_state.window_id = vim.api.nvim_open_win(current_state.buffer_id, true, {
			title = title or "",
			relative = "win",
			row = WINDOW.VERTICAL_MIDDLE_POS - WINDOW.HALF_HEIGHT,
			col = WINDOW.HORIZONTAL_MIDDLE_POS - WINDOW.HALF_WIDTH,
			width = WINDOW.WIDTH,
			height = WINDOW.HEIGHT,
			zindex = 200,
		})

		return current_state
	end

	return window_toggler
end

return Utils
