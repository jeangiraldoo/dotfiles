vim.cmd "colorscheme catppuccin"

require("vim._core.ui2").enable {
	enable = true,
}

vim.diagnostic.config {
	float = {
		scope = "line",
		header = "診断メッセージ",
	},
	signs = false,
	severity_sort = true,
}

vim.api.nvim_set_hl(0, "PMenuMatch", { fg = "#ffffff" })
vim.api.nvim_set_hl(0, "PMenuMatchSel", { fg = "#ffffff" })
vim.api.nvim_set_hl(0, "YankLine", { bg = "#d79921", fg = "#FFFFFF" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true, fg = "#ff5555" })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { bg = "orange" })

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
