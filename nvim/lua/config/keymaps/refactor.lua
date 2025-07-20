return {
	{
		desc = "Rename symbol",
		mode = "n",
		keys = "<leader>rn",
		cmd = vim.lsp.buf.rename,
	},
	{
		desc = "Toogle case",
		mode = "n",
		keys = "<leader>ru",
		cmd = "viw~",
	},
	{
		desc = "Toogle boolean",
		mode = "n",
		keys = "<leader>rb",
		cmd = function()
			local word = vim.fn.expand("<cword>")
			local bools = {
				["True"] = "False",
				["False"] = "True",
				["true"] = "false",
				["false"] = "true",
			}
			local replacement = bools[word]

			if replacement then
				vim.cmd("normal! ciw" .. replacement)
			end
		end,
	},
}
