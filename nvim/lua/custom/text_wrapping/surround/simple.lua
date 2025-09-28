--- This module provides basic functionality for surrounding a visual selection with a single opening/closing character pair.
--- It can be used as a standalone solution for simple wrapping, or as a foundation for building more complex behavior.

local CHAR_PAIRS = require("custom.text_wrapping.surround._pair_index")

local SIMPLE_SURROUND = {}

function SIMPLE_SURROUND.INLINE(lines, col, char_data)
	local line = lines[1]
	local text_before_selection = line:sub(1, col.start - 1)
	local text_after_selection = line:sub(col.last + 1)
	local selection_text = line:sub(col.start, col.last)

	local surrounded_selection = char_data.OPENING .. selection_text .. char_data.CLOSING

	local new_line = text_before_selection .. surrounded_selection .. text_after_selection
	return { new_line }
end

function SIMPLE_SURROUND.MULTILINE(lines, col, char_data)
	local first_line = lines[1]
	local last_line = lines[#lines]

	local zero_based_col_start = col.start - 1

	local pre_selection = first_line:sub(1, zero_based_col_start) -- Uses 0-based to only include text up to (not including) the selected character
	local post_selection = last_line:sub(col.last + 1) -- Add 1 to skip the character under the cursor

	local first_line_selection = first_line:sub(col.start)

	local new_first_line = pre_selection .. char_data.OPENING .. first_line_selection
	local new_lines = { new_first_line }

	local FIRST_INDEX = 2 -- The first line is already processed and inserted
	local LAST_INDEX = #lines - 1 -- The last line is going to be processed and inserted separately

	for i = FIRST_INDEX, LAST_INDEX do
		table.insert(new_lines, lines[i])
	end

	local new_last_line
	if vim.fn.visualmode() == "V" then
		-- In linewise mode, the entire line is selected; column doesn't matter. Using col.last would yield the same result
		local last_line_selection = last_line:sub(1, #last_line)
		new_last_line = last_line_selection .. char_data.CLOSING
	else
		local last_line_selection = last_line:sub(1, col.last)
		new_last_line = last_line_selection .. char_data.CLOSING .. post_selection
	end

	table.insert(new_lines, new_last_line)

	return new_lines
end

function SIMPLE_SURROUND._apply(char_data)
	--- Row values are 1-based, column values are 0-based
	local selection_start_pos, selection_end_pos = vim.api.nvim_buf_get_mark(0, "<"), vim.api.nvim_buf_get_mark(0, ">")

	local selection_pos = {
		row = {
			start = selection_start_pos[1] - 1,
			last = selection_end_pos[1],
		},
		col = {
			start = selection_start_pos[2] + 1,
			last = selection_end_pos[2] + 1,
		},
	}

	local lines = vim.api.nvim_buf_get_lines(0, selection_pos.row.start, selection_pos.row.last, false)
	if not lines or #lines == 0 then
		return
	end

	local is_inline_selection = #lines == 1
	local handler = is_inline_selection and SIMPLE_SURROUND.INLINE or SIMPLE_SURROUND.MULTILINE
	local surrounded_text = handler(lines, selection_pos.col, char_data)

	vim.api.nvim_buf_set_lines(0, selection_pos.row.start, selection_pos.row.last, false, surrounded_text)
end

function SIMPLE_SURROUND.RUN()
	local typed_char = vim.fn.getcharstr()

	local ESC_ASCII_CODE = 27
	if typed_char == string.char(ESC_ASCII_CODE) then
		return
	end
	local char_data = CHAR_PAIRS[typed_char]

	if not char_data then
		return
	end

	SIMPLE_SURROUND._apply(char_data)
end

return SIMPLE_SURROUND
