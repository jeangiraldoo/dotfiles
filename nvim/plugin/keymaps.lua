local utils = require("utils")
local runner = require("custom.runner")

local WORD_TOGGLE_MAP = {
	["True"] = "False",
	["False"] = "True",
	["true"] = "false",
	["false"] = "true",

	["on"] = "off",
	["off"] = "on",
	["ON"] = "OFF",
	["OFF"] = "ON",

	["enabled"] = "disabled",
	["disabled"] = "enabled",

	["public"] = "private",
	["private"] = "public",

	["up"] = "down",
	["down"] = "up",

	["break"] = "continue",
	["continue"] = "break",

	["fg"] = "bg",
	["bg"] = "fg",
	["foreground"] = "background",
	["background"] = "foreground",

	["local"] = "remote",
	["remote"] = "local",

	["==="] = "!==",
	["!=="] = "===",

	["and"] = "or",
	["or"] = "and",
	["&&"] = "||",
	["||"] = "&&",

	["=="] = "!=",
	["!="] = "==",
	[">"] = "<",
	["<"] = ">",
	[">="] = "<=",
	["<="] = ">=",

	["++"] = "--",
	["--"] = "++",
}

local KEYMAPS = {
	-- Admin
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
		cmd = utils.terminal.launch,
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
	-- Code editing
	{
		desc = "Go to symbol declaration",
		mode = "n",
		keys = "<leader>sd",
		cmd = vim.lsp.buf.definition,
	},
	{
		desc = "Go to call",
		mode = "n",
		keys = "<leader>sf",
		cmd = vim.lsp.buf.outgoing_calls,
	},
	{
		desc = "Toggle inlay hints",
		mode = "n",
		keys = "<leader>sh",
		cmd = function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end,
	},
	{
		desc = "Toggle word under the cursor",
		mode = "n",
		keys = "<leader>st",
		cmd = function()
			local word = vim.fn.expand("<cword>")

			local replacement = WORD_TOGGLE_MAP[word]

			if not replacement then
				return
			end
			vim.cmd.normal("ciw" .. replacement)
		end,
	},
	{
		desc = "Surround a visual selection with an opening/closing character pair",
		mode = { "x" },
		keys = "<leader>ls",
		cmd = [[:<C-u>lua require("custom.text_wrapping").surround.simple.RUN()<CR>]],
	},
	{
		desc = "Surround a visual selection with one or more opening/closing character pairs",
		mode = { "x" },
		keys = "<leader>lS",
		cmd = [[:<C-u>lua require("custom.text_wrapping").surround.extended()<CR>]],
	},
	-- Files
	{
		desc = "Display file tree",
		mode = "n",
		keys = "<leader>fM",
		cmd = function()
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)
				local is_netrw_open = vim.bo[buf].filetype == "netrw"
				if is_netrw_open then
					vim.api.nvim_win_close(win, true)
					return
				end
			end

			vim.cmd("Vexplore")
		end,
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
	-- Window management
	{
		desc = "Increase vertical split",
		mode = "n",
		keys = "<C-Up>",
		cmd = ":vertical resize +3 <CR>",
	},
	{
		desc = "Decrease vertical split",
		mode = "n",
		keys = "<C-Down>",
		cmd = ":vertical resize -3 <CR>",
	},
}

utils.editor.set_keymaps(KEYMAPS)
