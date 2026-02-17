local utils = require("utils")

local RESET_HL = "%#StatusLine#" -- Used to reset/close any active highlights

utils.editor.set_highlights({
	statusline_section_text = {
		bg = "#1e2030",
		fg = "#d79921",
	},
	StatusLineGitText = {
		fg = "#d79921",
		bg = "#1e2030",
	},
	statusline_git_icon = {
		fg = "#d79921",
		bg = "#b84500",
	},
	statusline_section = {
		bg = "#d79921",
	},
})

return function()
	local statusline_str = table.concat({
		(
			"%#statusline_section#█%#statusline_git_icon# "
			.. "%#statusline_section_text#"
			.. (vim.b.gitsigns_head or "[No Branch]")
			.. "%#statusline_section#█"
		),
		(RESET_HL .. "%f" .. (vim.bo.modified and " %#WhiteText#●" or "")),
		"%=",
		("%#DiagnosticWarn#☢" .. RESET_HL .. " " .. #vim.diagnostic.get(0)),
		"%#statusline_section#" .. "%#statusline_section_text#󰆌  %l:%c " .. "%#statusline_section█",
	}, " ")

	return statusline_str
end
