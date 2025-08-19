local opts = {
	ruler = true,
	number = true,
	relativenumber = true,
	cursorline = true,
	scroll = 10,
	mouse = "",
	tabstop = 4,
	shiftwidth = 4,
	foldenable = true,
	foldmethod = "manual",
	foldcolumn = "1",
	listchars = {
		tab = "» ",
		trail = "·",
		eol = "¬",
		extends = "›",
		precedes = "‹",
		space = "·",
	},
}

for opt_name, value in pairs(opts) do
	vim.opt[opt_name] = value
end
