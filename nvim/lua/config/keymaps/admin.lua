return {
	{
		desc = "Open plugin manager menu",
		mode = "n",
		keys = "<leader>aa",
		cmd = ":Lazy<CR>",
	},
	{
		desc = "Open Neovim config",
		mode = { "n", "v" },
		keys = "<leader>.",
		cmd = function()
			local config_path = vim.fn.expand("~/.config/nvim/init.lua")
			local term_cmd = { "wezterm", "cli", "spawn" }
			local nvim_cmd = { "nvim", config_path }
			if vim.api.nvim_buf_get_name(0) == "" then
				vim.cmd("edit " .. config_path)
			else
				local final = vim.list_extend(term_cmd, nvim_cmd)
				vim.fn.jobstart(final, { detach = true })
			end
		end,
	},
	{
		desc = "Display messages",
		mode = "n",
		keys = "<leader>m",
		cmd = ":messages<CR>",
	},
	{
		desc = "Toggle hidden characters",
		mode = "n",
		keys = "<leader>ee",
		cmd = function()
			vim.o.list = not vim.o.list
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
}
