local utils = require "utils"

utils.editor.set_keymaps {
	(function()
		local window_toggler = utils.editor.build_window_toggler()

		return {
			desc = "Toggle version control window",
			mode = "n",
			keys = "<leader>gg",
			cmd = function()
				local toggle_state = window_toggler()
				if vim.api.nvim_buf_get_name(toggle_state.buffer_id) == "" then
					vim.cmd "term lazygit"
				end
			end,
		}
	end)(),
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
		keys = "<C- >",
		cmd = [[<C-\><C-n>]],
	},
	{
		desc = "Launch runner menu",
		mode = "n",
		keys = "<leader>ar",
		cmd = require("runner").display_menu,
	},
	-- Code editing
	(function()
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

		return {
			desc = "Toggle word under the cursor",
			mode = "n",
			keys = "<leader>st",
			cmd = function()
				local word_under_cursor = vim.fn.expand "<cword>"
				local replacement = WORD_TOGGLE_MAP[word_under_cursor]

				if replacement then
					vim.cmd.normal("ciw" .. replacement)
				end
			end,
		}
	end)(),
	{
		desc = "Toggle location list with diagnostics",
		mode = "n",
		keys = "<leader>ld",
		cmd = function()
			for _, win in ipairs(vim.fn.getwininfo()) do
				if win.loclist == 1 then
					vim.cmd "lclose"
					return
				end
			end

			vim.diagnostic.setloclist()
		end,
	},
	(function()
		local window_toggler = utils.editor.build_window_toggler()

		return {
			desc = "Toggle notes",
			mode = "n",
			keys = "<leader>tn",
			cmd = function()
				local toggle_state = window_toggler()

				if vim.api.nvim_buf_get_name(toggle_state.buffer_id) == "" then
					vim.cmd "silent edit ~/.notes.md"
				end
			end,
		}
	end)(),
}
