local utils = require "utils"

function _G.build_statusline()
	local RESET_HL = "%#StatusLine#"

	local git_section = "%#statusline_section#█%#statusline_git_icon# "
		.. "%#statusline_section_text#"
		.. (vim.b.gitsigns_head or "[No Branch]")
		.. "%#statusline_section#█"

	local file_section = RESET_HL .. "%f" .. (vim.bo.modified and " %#WhiteText#●" or "")

	local diagnostics_section = "%#DiagnosticWarn#☢" .. RESET_HL .. " " .. #vim.diagnostic.get(0)

	local position_section = "%#statusline_section#"
		.. "%#statusline_section_text#󰆌  %l:%c "
		.. "%#statusline_section█"

	return table.concat({
		git_section,
		file_section,
		"%=",
		diagnostics_section,
		position_section,
	}, " ")
end

require("utils").editor.set_highlights {
	PMenuMatch = {
		fg = "#ffffff",
	},
	PMenuMatchSel = {
		fg = "#ffffff",
	},
	YankLine = {
		bg = "#d79921",
		fg = "#FFFFFF",
	},
	DiagnosticUnderlineError = {
		underline = true,
		fg = "#ff5555",
	},
	DiagnosticWarn = {
		bg = "orange",
	},
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
}

utils.editor.set_autocmds {
	{
		desc = "Load view",
		event = "BufWinEnter",
		pattern = "*",
		command = "silent! loadview",
	},
	{
		desc = "Make view",
		event = "BufWinLeave",
		pattern = "*",
		command = "silent! mkview",
	},
	{
		desc = "Highlight yanked line",
		pattern = "*",
		event = "TextYankPost",
		callback = function()
			vim.highlight.on_yank {
				timeout = 200,
				higroup = "YankLine",
			}
		end,
	},
	{
		desc = "Start Treesitter syntax highlight",
		event = "FileType",
		callback = function(args)
			pcall(vim.treesitter.start, args.buf)
		end,
	},
	{
		desc = "Open help buffers in a vertical split",
		event = "BufWinEnter",
		callback = function()
			if vim.bo.buftype ~= "help" then
				return
			end

			pcall(vim.cmd, "wincmd L")
		end,
	},
}
