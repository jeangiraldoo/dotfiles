local OPTS = {
	shiftwidth = 2,
	softtabstop = 2,
	cursorcolumn = false,
	comments = { "b:-", "b:*" },
}

for opt_name, value in pairs(OPTS) do
	vim.opt_local[opt_name] = value
end

vim.opt_local.formatoptions:append("ro")

vim.keymap.set("i", "<CR>", function()
	local line = vim.api.nvim_get_current_line()

	if not line:match("^%s*[-*]%s*$") then
		return vim.api.nvim_replace_termcodes("<CR>", true, false, true)
	end

	-- vim.schedule(function()
	local row = vim.api.nvim_win_get_cursor(0)[1] -- 1-based current line number
	vim.api.nvim_buf_set_lines(0, row - 2, row - 1, false, { "" })
	vim.api.nvim_set_current_line("")
	-- end)
	-- default: behave like a normal Enter
end, { expr = true, noremap = true, buffer = true })
