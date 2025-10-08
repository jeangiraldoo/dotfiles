local Terminal = {}

--- Launches a configurable terminal using a vertical split.
--- @param opts table A table with the following optional settings:
--- * `cmd`: The shell command to run.
--- * `close_after_cmd`: Whether or not to close the terminal after running a command.
---   Mimicks running a command in the background.
--- * `cwd`: The working directory to run the command from.
--- @return nil
function Terminal.launch(opts)
	opts = opts or {}
	local shell = {
		windows = {
			shell_only = "powershell -NoLogo",
			cmd_with_shell = "%s & powershell -NoLogo",
		},
		linux = {
			shell_only = "bash",
			cmd_with_shell = "%s ; bash",
		},
		mac = {
			shell_only = "zsh",
			cmd_with_shell = "%s ; zsh",
		},
	}
	local os_name = vim.loop.os_uname().sysname:lower()
	if os_name == "windows_nt" then
		os_name = "windows"
	elseif os_name == "darwin" then
		os_name = "mac"
	end

	local os_shell_cmds = shell[os_name]
	if not os_shell_cmds then
		vim.notify_once("Unsupported OS: " .. os_name, vim.log.levels.ERROR)
		return
	end

	local cmd
	if opts.cmd then
		local cmd_template = os_shell_cmds.cmd_with_shell
		cmd = string.format(cmd_template, opts.cmd)
	else
		cmd = os_shell_cmds.shell_only
	end

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
