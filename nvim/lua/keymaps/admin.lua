local utils = require("utils")
local runner = require("custom.runner")

return {
	{
		desc = "Display messages",
		mode = "n",
		keys = "<leader>am",
		cmd = ":messages<CR>",
	},
	{
		desc = "Toggle hidden characters",
		mode = "n",
		keys = "<leader>aH",
		cmd = function()
			vim.o.list = not vim.o.list
		end,
	},
	{
		desc = "Launch terminal",
		mode = "n",
		keys = "<leader>at",
		cmd = function()
			utils.terminal.launch()
		end,
	},
	{
		desc = "Exit terminal mode",
		mode = "t",
		keys = "<Esc>",
		cmd = [[<C-\><C-n>]],
	},
	{
		desc = "Re-enter insert mode in terminal",
		mode = "t",
		keys = "<C-i>",
		cmd = "i",
	},
	{
		desc = "Run file",
		mode = "n",
		keys = "<leader>ar",
		cmd = function()
			runner.run({ run_current_file = true })
		end,
	},
	{
		desc = "Run project",
		mode = "n",
		keys = "<leader>aR",
		cmd = function()
			runner.run({ run_current_file = false })
		end,
	},
	{
		desc = "Display installed plugins",
		mode = "n",
		keys = "<leader>ae",
		cmd = function()
			print(vim.inspect(vim.pack.get()))
		end,
	},
	{
		desc = "Move up an item menu",
		mode = "i",
		keys = "<C-k>",
		cmd = "<C-p>",
	},

	{
		desc = "Move down an item menu",
		mode = "i",
		keys = "<C-j>",
		cmd = "<C-n>",
	},
	{
		desc = "Display diagnostics window",
		mode = "n",
		keys = "<leader>ad",
		cmd = vim.diagnostic.open_float,
	},
	{
		desc = "Toggle inlay hints",
		mode = "n",
		keys = "<leader>ah",
		cmd = function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end,
	},
	{
		desc = "Toggle undotree",
		mode = { "n" },
		keys = "U",
		cmd = ":Undotree<CR>",
	},
}
