local utils = require("utils")
local code_runner = require("custom.code_runner")

local function select_github_action(action_type, available_actions)
	local is_dict = not vim.islist(available_actions)
	local actions = is_dict and vim.tbl_keys(available_actions) or available_actions
	vim.ui.select(actions, {
		prompt = string.format("🐙 Available %s actions: ", action_type),
	}, function(choice)
		if not choice then
			return
		end

		local cmd = "Octo " .. action_type .. " " .. choice

		if not is_dict then
			vim.cmd(cmd)
			return
		end

		local subcmd_initiliazer = available_actions[choice]
		subcmd_initiliazer(function(subcmd)
			local cmd_with_subcmd = string.format("%s %s", cmd, subcmd)
			vim.cmd(cmd_with_subcmd)
		end)
	end)
end

return {
	{
		desc = "Record actions",
		mode = "n",
		keys = "<leader>z",
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
		desc = "Display file tree",
		mode = "n",
		keys = "<leader>pt",
		cmd = ":Neotree right toggle<CR>",
	},
	{
		desc = "Open fuzzy finder",
		mode = "n",
		keys = "<leader>ps",
		cmd = ":FzfLua files<CR>",
	},
	{
		desc = "Open file manager",
		mode = "n",
		keys = "<leader>pf",
		cmd = ":Oil <CR>",
	},
	{
		desc = "Run file",
		mode = "n",
		keys = "<leader>lf",
		cmd = function()
			code_runner.run_file()
		end,
	},
	{
		desc = "Run project",
		mode = "n",
		keys = "<leader>lp",
		cmd = function()
			code_runner.run_project()
		end,
	},
	{
		desc = "Launch terminal",
		mode = "n",
		keys = "<leader>tt",
		cmd = function()
			utils.launch_terminal()
		end,
	},
	{
		desc = "Toggle inline Git blame",
		mode = "n",
		keys = "<leader>pb",
		cmd = ":Gitsigns toggle_current_line_blame<CR>",
	},
	{
		desc = "Open buffer Git blame",
		mode = "n",
		keys = "<leader>pB",
		cmd = ":Gitsigns blame<CR>",
	},
	{
		desc = "Display Github issue actions",
		mode = "n",
		keys = "<leader>pi",
		cmd = function()
			select_github_action("issue", {
				"list",
				"create",
				"close",
				"reopen",
				"edit",
				"reload",
				"url",
			})
		end,
	},
	{
		desc = "Display Github discussion actions",
		mode = "n",
		keys = "<leader>pd",
		cmd = function()
			select_github_action("discussion", {
				"list",
				"create",
				"close",
				"reopen",
				"reload",
				"search",
			})
		end,
	},
	{
		desc = "Display Github repo actions",
		mode = "n",
		keys = "<leader>pr",
		cmd = function()
			select_github_action("repo", {
				"list",
				"fork",
				"browser",
				"url",
			})
		end,
	},
	{
		desc = "Display Github reaction options",
		mode = "n",
		keys = "<leader>pe",
		cmd = function()
			select_github_action("reaction", {
				"thumbs_up",
				"thumbs_down",
				"eyes",
				"laugh",
				"confused",
				"rocket",
				"heart",
				"party",
			})
		end,
	},
	{
		desc = "Display Github comment options",
		mode = "n",
		keys = "<leader>pc",
		cmd = function()
			select_github_action("comment", {
				"add",
				"reply",
				"suggest",
				"delete",
				"url",
			})
		end,
	},
	{
		desc = "Display Github pull request options",
		mode = "n",
		keys = "<leader>pp",
		cmd = function()
			select_github_action("pr", {
				"list",
				"create",
				"close",
				"reopen",
				"edit",
				"commits",
				"diff",
				"url",
				"reload",
				"checkout",
				"runs",
				"checks",
			})
		end,
	},
	{
		desc = "Display Github workflow runs",
		mode = "n",
		keys = "<leader>pw",
		cmd = ":Octo run list<CR>",
	},
	{
		desc = "Display Github notifications",
		mode = "n",
		keys = "<leader>pn",
		cmd = ":Octo notification list<CR>",
	},
	{
		desc = "Assign something to an user on Github",
		mode = "n",
		keys = "<leader>pa",
		cmd = function()
			local function use_assignee_name_as_subcmd(run_with_subcmd)
				print("CALLED")
				vim.ui.input({ prompt = "Assignee username: " }, function(name)
					if not name then
						return
					end
					run_with_subcmd(name)
				end)
			end
			select_github_action("assignee", {
				add = use_assignee_name_as_subcmd,
				remove = use_assignee_name_as_subcmd,
			})
		end,
	},
}
