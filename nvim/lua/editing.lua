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
		desc = "Swap comma-separated items",
		mode = "n",
		keys = "cp",
		cmd = function()
			local current_line = vim.api.nvim_get_current_line()
			local substring_start_pos, substring_end_pos = current_line:find "[%w][%w_]*,%s*[%w][%w_ ]*[, %w_]*"

			if not (substring_start_pos and substring_end_pos) then
				vim.notify("No comma-separated match found", vim.log.levels.WARN)
				return
			end

			local original_substring = current_line:sub(substring_end_pos, substring_start_pos)

			local cursor_col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- 1-based
			if not (cursor_col >= substring_start_pos and cursor_col <= substring_end_pos) then
				vim.notify("Cursor is not within the comma-separated substring boundaries", vim.log.levels.WARN)
				return
			end

			local items = vim.split(original_substring, ",")

			local substring_cursor_col_offset = cursor_col - substring_start_pos

			local length_accumulator = 0
			local item_under_cursor_pos, item_under_cursor = vim.iter(items):enumerate():find(function(_, v)
				length_accumulator = length_accumulator + #v + 1 -- +1 because cursor_col accounts for commas, but in items they were removed

				-- If adding the length of the current item to the accumulator makes it >= to the column offset
				-- it means the offset is on a character of the current item
				return substring_cursor_col_offset <= length_accumulator
			end)

			-- Defaults to 2 as it allows to seamlessly perform a swap when there's only 2 items
			local target_item_pos = vim.v.count1
			target_item_pos = target_item_pos ~= 1 and target_item_pos or 2

			if target_item_pos > #items then
				vim.notify("Chosen position is greater than the amount of comma-separated items", vim.log.levels.WARN)
				return
			end

			items[item_under_cursor_pos] = items[target_item_pos]
			items[target_item_pos] = item_under_cursor

			for index, value in ipairs(items) do
				items[index] = vim.trim(value)
			end

			local rearranged_substring = table.concat(items, ", ")
			vim.api.nvim_set_current_line(current_line:gsub(original_substring, rearranged_substring))
		end,
	},
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
