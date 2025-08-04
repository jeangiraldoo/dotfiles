local utils = require("utils")

return {
	{
		desc = "Comment line/s",
		mode = { "n", "v" },
		keys = "<leader>cc",
		cmd = function()
			if vim.fn.mode():match("v") then
				local keys = vim.api.nvim_replace_termcodes("gc", true, false, true)
				vim.api.nvim_feedkeys(keys, "x", false)
			else
				vim.cmd("normal gcc")
			end
		end,
	},
	{
		desc = "Swap lines above",
		mode = "n",
		keys = "<leader>la",
		cmd = ":m .-2<CR>==",
	},
	{
		desc = "Swap lines below",
		mode = "n",
		keys = "<leader>lb",
		cmd = ":m .+1<CR>==",
	},
	{
		desc = "Duplicate lines",
		mode = "v",
		keys = "<leader>ld",
		cmd = ":y<CR>'>p",
	},
	{
		desc = "Duplicate line",
		mode = "n",
		keys = "<leader>ld",
		cmd = ":t.<CR>",
	},
	{
		desc = "Add new empty line",
		mode = "n",
		keys = "O",
		cmd = "o<Esc>",
	},
	{
		desc = "Copy to clipboard",
		mode = { "n", "v" },
		keys = "<leader>y",
		cmd = ":y+ <CR>",
	},
	{
		desc = "Paste from clipboard",
		mode = { "n", "v" },
		keys = "<leader>p",
		cmd = '"+p',
	},
	{
		desc = "Select all lines",
		mode = { "n", "v" },
		keys = "<leader>al",
		cmd = "ggvG",
	},
	{
		desc = "Toggle AI chat",
		mode = { "n", "v" },
		keys = "<leader>ap",
		cmd = function()
			utils.launch_terminal({
				cmd = "ollama serve",
				close_after_cmd = true,
			})
			vim.cmd("CodeCompanionChat Toggle")
		end,
	},
	{
		desc = "Open color picker",
		mode = { "n", "v" },
		keys = "<leader>ew",
		cmd = ":CccPick<CR>",
	},
}
