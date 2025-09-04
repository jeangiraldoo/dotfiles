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
	complete = "",
	completeopt = "menuone,noselect,popup,preview",
	pumheight = 12,
}

for opt_name, value in pairs(OPTS) do
	vim.opt[opt_name] = value
end
