local OPTS = {
	number = true,
	relativenumber = true,
	cursorline = true,
	cursorcolumn = true,
	scroll = 10,
	mouse = "",
	tabstop = 4,
	shiftwidth = 4,
	statusline = "%!v:lua.require'statusline'.build_statusline()",
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
	scrolloff = 10,
	showmode = false,
	winborder = "rounded",
	autocomplete = true,
	completeopt = "menuone,noselect,popup,preview",
	complete = ".",
	pumheight = 12,
	pumborder = "rounded",
}

for opt_name, value in pairs(OPTS) do
	vim.opt[opt_name] = value
end
