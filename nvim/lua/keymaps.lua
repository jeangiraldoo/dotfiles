local utils = require("utils")
local runner = require("runner.init")

local WORD_TOGGLE_MAP = vim.iter({
	["True"] = "False",
	["true"] = "false",
	["on"] = "off",
	["ON"] = "OFF",
	["enabled"] = "disabled",
	["public"] = "private",
	["fg"] = "bg",
	["==="] = "!==",
	["and"] = "or",
	["&&"] = "||",
	["=="] = "!=",
	[">"] = "<",
	[">="] = "<=",
	["++"] = "--",
}):fold({}, function(acc, key, value)
	acc[key] = value
	acc[value] = key
	return acc
end)

local KEYMAPS = {
	{
		desc = "Toggle version control window",
		mode = "n",
		keys = "<leader>gg",
		cmd = function()
			local is_window_displayed = utils.editor.toggle_floating_window(function()
				return vim.api.nvim_buf_get_name(0):match("git$")
			end, "Version control")

			if not is_window_displayed then
				return
			end

			vim.cmd("term lazygit")
		end,
	},
	-- Admin
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
		desc = "Launch runner menu",
		mode = "n",
		keys = "<leader>ar",
		cmd = runner.display_menu,
	},
	{
		desc = "Display installed plugins",
		mode = "n",
		keys = "<leader>ae",
		cmd = function()
			local plugin_list = vim.pack.get()
			local plugin_info_format = "Name: %s\nActive: %s\nSrc: %s\nPath: %s\n\n"

			for _, plugin_spec in ipairs(plugin_list) do
				local formatted_plugin_info = plugin_info_format:format(
					plugin_spec.spec.name,
					plugin_spec.active,
					plugin_spec.spec.src,
					plugin_spec.path
				)
				vim.notify(formatted_plugin_info)
			end
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
	{
		desc = "Toggle virtual text",
		mode = "n",
		keys = "<leader>av",
		cmd = function()
			vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
		end,
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
			local word_under_cursor = vim.fn.expand("<cword>")
			local replacement = WORD_TOGGLE_MAP[word_under_cursor]

			if replacement then
				vim.cmd.normal("ciw" .. replacement)
			end
		end,
	},
	{
		desc = "Add new empty line",
		mode = "n",
		keys = "O",
		cmd = "o<Esc>",
	},
	{
		desc = "Toggle casefile floating window",
		mode = "n",
		keys = "<leader>dn",
		cmd = function()
			local FILE_NAME = "casefile.md"
			local is_window_displayed = utils.editor.toggle_floating_window(function()
				return vim.api.nvim_buf_get_name(0):match(FILE_NAME .. "$")
			end, "Casefile")

			if not is_window_displayed then
				return
			end

			local target_path = vim.fs.root(0, { FILE_NAME }) or vim.fs.root(0, { ".git" })
			local casefile_path = target_path and vim.fs.joinpath(target_path, FILE_NAME) or FILE_NAME

			vim.cmd("edit " .. casefile_path)
		end,
	},
}

utils.editor.set_keymaps(KEYMAPS)
