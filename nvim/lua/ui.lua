-- local utils = require "utils"

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

vim.api.nvim_set_hl(0, "PMenuMatch", { fg = "#ffffff" })
vim.api.nvim_set_hl(0, "PMenuMatchSel", { fg = "#ffffff" })
vim.api.nvim_set_hl(0, "YankLine", { bg = "#d79921", fg = "#FFFFFF" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true, fg = "#ff5555" })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { bg = "orange" })
vim.api.nvim_set_hl(0, "statusline_section_text", { bg = "#1e2030", fg = "#d79921" })
vim.api.nvim_set_hl(0, "StatusLineGitText", { fg = "#d79921", bg = "#1e2030" })
vim.api.nvim_set_hl(0, "statusline_git_icon", { fg = "#d79921", bg = "#b84500" })
vim.api.nvim_set_hl(0, "statusline_section", { bg = "#d79921" })

vim.api.nvim_create_autocmd("BufWinEnter", { desc = "Load view", pattern = "*", command = "silent! loadview" })
vim.api.nvim_create_autocmd("BufWinLeave", { desc = "Make view", pattern = "*", command = "silent! mkview" })
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight yanked line",
	pattern = "*",
	callback = function()
		vim.hl.on_yank {
			timeout = 200,
			higroup = "YankLine",
		}
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	desc = "Start Treesitter syntax highlight",
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})
vim.api.nvim_create_autocmd("BufWinEnter", {
	desc = "Open help buffers in a vertical split",
	callback = function()
		if vim.bo.buftype == "help" then
			vim.cmd "wincmd L"
		end
	end,
})
