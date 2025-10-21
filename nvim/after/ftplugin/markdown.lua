local OPTS = {
	shiftwidth = 2,
	softtabstop = 2,
	cursorcolumn = false,
}

for opt_name, value in pairs(OPTS) do
	vim.opt_local[opt_name] = value
end
