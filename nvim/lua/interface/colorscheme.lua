local COLORSCHEME_NAME = "tokyonight-moon"

if not (vim.g.colors_name == COLORSCHEME_NAME) then
	vim.cmd("colorscheme " .. COLORSCHEME_NAME)
end
