local utils = require "utils"

vim.keymap.set(
	"n",
	"<leader>gg",
	(function()
		local window_toggler = utils.build_window_toggler()

		return function()
			local toggle_state = window_toggler()
			if vim.api.nvim_buf_get_name(toggle_state.buffer_id) == "" then
				vim.cmd "term lazygit"
			end
		end
	end)(),
	{ desc = "Toggle version control window", silent = true }
)
vim.keymap.set("t", "<C- >", [[<C-\><C-n>]], { desc = "Exit terminal mode", silent = true })
vim.keymap.set("n", "<leader>ar", require("runner").display_menu, { desc = "Launch runner menu", silent = true })
vim.keymap.set(
	"n",
	"<leader>st",
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

		return function()
			local word_under_cursor = vim.fn.expand "<cWORD>"
			local replacement = WORD_TOGGLE_MAP[word_under_cursor]

			if replacement then
				vim.cmd.normal("ciw" .. replacement)
			end
		end
	end)(),
	{ desc = "Toggle the word under the cursor", silent = true }
)
vim.keymap.set(
	"n",
	"<leader>tn",
	(function()
		local window_toggler = utils.build_window_toggler()

		return function()
			local toggle_state = window_toggler()

			if vim.api.nvim_buf_get_name(toggle_state.buffer_id) == "" then
				vim.cmd "silent edit ~/.notes.md"
			end
		end
	end)(),
	{ desc = "Toggle notes", silent = true }
)
vim.keymap.set(
	"n",
	"<leader>tt",
	(function()
		local window_toggler = utils.build_window_toggler()

		return function()
			local toggle_state = window_toggler()

			if vim.api.nvim_buf_get_name(toggle_state.buffer_id) == "" then
				vim.cmd "silent term"
			end
		end
	end)(),
	{ desc = "Toggle floating terminal", silent = true }
)
