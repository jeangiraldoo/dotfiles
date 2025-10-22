--- This module extends the basic surround functionality by allowing users to define multi-character pairs
--- to wrap a selection, rather than being limited to single-character surrounds.
---
--- The simple surround module uses a table with `OPENING` and `CLOSING` keys to define the surrounding pair.
--- By default, it supports only single-character wraps, but this module enables multi-character wrapping
--- by assigning multiple characters to each of those keys.

local PAIRS_DATA = require("text_wrapping.surround._pair_index")
local simple_surround = require("text_wrapping.surround.simple")

return function()
	local typed_chars = vim.fn.input("Surround characters: ")

	local data_accumulator = {
		OPENING = "",
		CLOSING = "",
	}

	for i = 1, #typed_chars do
		local char = typed_chars:sub(i, i)
		local data = PAIRS_DATA[char]
		data_accumulator.OPENING = data_accumulator.OPENING .. data.OPENING

		-- The closing character is prepended to the CLOSING accumulator to mirror the order of opening characters.
		-- For example, in `{ ("hi") }`, the opening parenthesis is the last opening character (left to right),
		-- so its corresponding closing parenthesis should be the first in the closing sequence
		data_accumulator.CLOSING = data.CLOSING .. data_accumulator.CLOSING
	end

	simple_surround._apply(data_accumulator)
end
