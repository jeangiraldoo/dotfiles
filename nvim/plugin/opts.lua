local OPTS = {
	number = true,
	relativenumber = true,
	cursorline = true,
	cursorcolumn = true,
	scroll = 10,
	mouse = "",
	tabstop = 4,
	shiftwidth = 4,
	statusline = "%!v:lua.require'interface.statusline'.build_statusline()",
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
	pumheight = 12,
	pumborder = "rounded",
}

for opt_name, value in pairs(OPTS) do
	vim.opt[opt_name] = value
end

local GLOBALS = {
	netrw_liststyle = 3, -- tree mode
	netrw_banner = 0, -- hide banner
	netrw_winsize = 25, -- window width
	netrw_altv = 1, -- splits open to the right
	netrw_browse_split = 4, -- open files in the previous window
	netrw_tree_indent = 2,
}

for global_name, value in pairs(GLOBALS) do
	vim.g[global_name] = value
end
