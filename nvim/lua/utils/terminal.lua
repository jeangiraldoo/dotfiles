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

return Terminal
