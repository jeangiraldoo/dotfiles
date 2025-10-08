local Terminal = {}

local OS_NAME = vim.loop.os_uname().sysname:lower()
local DEFAULT_SYSTEM_SHELL_CMD = OS_NAME == "windows_nt" and "powershell -NoLogo" or "$SHELL"
local CMD_STRUCTURE = "%s ; " .. DEFAULT_SYSTEM_SHELL_CMD

--- Launches a configurable terminal using a vertical split.
--- @param opts table A table with the following optional settings:
--- * `cmd`: The shell command to run.
--- * `close_after_cmd`: Whether or not to close the terminal after running a command.
---   Mimicks running a command in the background.
--- * `cwd`: The working directory to run the command from.
--- @return nil
function Terminal.launch(opts)
	opts = opts or {}

	local cmd = opts.cmd and CMD_STRUCTURE:format(opts.cmd) or DEFAULT_SYSTEM_SHELL_CMD

	vim.cmd("botright split | resize 15")
	local term_buf = vim.api.nvim_create_buf(false, true)

	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(win, term_buf)

	vim.fn.termopen(cmd, {
		cwd = opts.cwd or vim.fn.getcwd(),
	})

	-- Set buffer options to make it behave like a terminal
	vim.bo[term_buf].buftype = "terminal"
	vim.bo[term_buf].bufhidden = "hide"
	vim.bo[term_buf].swapfile = false

	if opts.close_after_cmd then
		vim.cmd("close")
	else
		vim.cmd("startinsert")
	end
end

return Terminal
