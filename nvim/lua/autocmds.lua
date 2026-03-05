	-- Session management
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
	-- UI
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

for _, autocmd in ipairs(AUTOCMDS) do
	-- Passing the autocmd table with an `event` field will result in an error
	local autocmd_event = autocmd.event
	autocmd.event = nil

	vim.api.nvim_create_autocmd(autocmd_event, autocmd)
end
