local utils = require("utils")
local runner = require("runner.init")

local casefile = {
	FILE_NAME = "casefile.md",
	window_id = nil,
	buffer_id = nil,
}

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
	{
		desc = "Toggle casefile floating window",
		mode = "n",
		keys = "<leader>dn",
		cmd = function()
			if not casefile.window_id then
				casefile.buffer_id = casefile.buffer_id or vim.api.nvim_create_buf(true, false)
				casefile.window_id = vim.api.nvim_open_win(casefile.buffer_id, true, {
					title = " 〘 Casefile 〙 ",
					title_pos = "center",
					relative = "win",
					row = 5,
					col = 20,
					width = 105,
					height = 22,
					zindex = 200,
					border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
				})

				local target_path = vim.fs.root(0, { "casefile.md" }) or vim.fs.root(0, { ".git" })

				local casefile_path = target_path and vim.fs.joinpath(target_path, casefile.FILE_NAME)
					or casefile.FILE_NAME

				vim.cmd("edit " .. casefile_path)
				return
			end

			vim.api.nvim_win_close(casefile.window_id, true)
			casefile.window_id = nil
		end,
	},
}

utils.editor.set_keymaps(KEYMAPS)
