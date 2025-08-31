local utils = require("utils")
local code_runner = require("custom.code_runner")

return {
	{
		desc = "Open plugin manager menu",
		mode = "n",
		keys = "<leader>ap",
		cmd = ":Lazy<CR>",
	},
	{
		desc = "Display messages",
		mode = "n",
		keys = "<leader>am",
		cmd = ":messages<CR>",
	},
	{
		desc = "Toggle hidden characters",
		mode = "n",
		keys = "<leader>ah",
		cmd = function()
			vim.o.list = not vim.o.list
		end,
	},
	{
		desc = "Launch terminal",
		mode = "n",
		keys = "<leader>at",
		cmd = function()
			utils.launch_terminal()
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
			code_runner.run_file()
		end,
	},
	{
		desc = "Run project",
		mode = "n",
		keys = "<leader>aR",
		cmd = function()
			code_runner.run_project()
		end,
	},
	{
		desc = "Record actions",
		mode = "n",
		keys = "<leader>az",
		cmd = function()
			local is_recording = vim.fn.reg_recording() ~= ""
			if is_recording then
				vim.api.nvim_feedkeys("q", "n", false)
			else
				vim.api.nvim_feedkeys("qq", "n", false)
			end
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
		desc = "Accept selected menu item",
		mode = "i",
		keys = "<CR>",
		cmd = function()
			vim.cmd([[inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"]])
		end,
	},
}
