local utils = require("utils")
local runner = require("runner.init")

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

	["fg"] = "bg",
	["bg"] = "fg",

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
