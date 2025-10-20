local function toggle_netrw()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local is_netrw_open = vim.bo[buf].filetype == "netrw"
		if is_netrw_open then
			vim.api.nvim_win_close(win, true)
			return
		end
	end

	vim.cmd("Vexplore")
end

return {
	{
		desc = "Display file tree",
		mode = "n",
		keys = "<leader>fM",
		cmd = toggle_netrw,
	},
	{
		desc = "Save file",
		mode = "n",
		keys = "<leader>w",
		cmd = ":w<CR>",
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
		desc = "Add new empty line",
		mode = "n",
		keys = "O",
		cmd = "o<Esc>",
	},
}
