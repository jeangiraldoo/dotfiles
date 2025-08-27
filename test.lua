-- local pattern = vim.lpeg.utfR(k)
local function is_grapheme(codepoint)
	local UPPERCASE_BASIC_LATIN_START = 65
	local UPPERCASE_BASIC_LATIN_END = 90

	if codepoint >= UPPERCASE_BASIC_LATIN_START and codepoint <= UPPERCASE_BASIC_LATIN_END then
		return true -- A-Z
	end

	local LOWERCASE_BASIC_LATIN_START = 97
	local LOWERCASE_BASIC_LATIN_END = 122

	if codepoint >= LOWERCASE_BASIC_LATIN_START and codepoint <= LOWERCASE_BASIC_LATIN_END then
		return true
	end

	local EXTRA_CHAR = 181 -- μ character
	local LATIN_1_START = 192
	local LATIN_1_END = 255

	if codepoint == EXTRA_CHAR or (codepoint >= LATIN_1_START and codepoint <= LATIN_1_END) then
		return true
	end

	local CYRILLIC_RANGE_START = 1024
	local CYRILLIC_RANGE_END = 1279

	if codepoint >= CYRILLIC_RANGE_START and codepoint <= CYRILLIC_RANGE_END then
		return true
	end

	return false
end

local function utf8_to_letters(str)
	local letters = {}
	local i = 1
	while i <= #str do
		local b1 = str:byte(i)
		local cp, bytes

		if b1 < 128 then
			-- 1-byte ASCII
			cp = b1
			bytes = 1
		elseif b1 < 224 then
			-- 2-byte sequence
			local b2 = str:byte(i + 1)
			cp = ((b1 % 32) * 64) + (b2 % 64)
			bytes = 2
		elseif b1 < 240 then
			-- 3-byte sequence
			local b2, b3 = str:byte(i + 1, i + 2)
			cp = ((b1 % 16) * 4096) + ((b2 % 64) * 64) + (b3 % 64)
			bytes = 3
		elseif b1 < 248 then
			-- 4-byte sequence
			local b2, b3, b4 = str:byte(i + 1, i + 3)
			cp = ((b1 % 8) * 262144) + ((b2 % 64) * 4096) + ((b3 % 64) * 64) + (b4 % 64)
			bytes = 4
		else
			-- invalid byte
			cp = b1
			bytes = 1
		end

		-- keep only letters (decimal codepoint ranges)
		if is_grapheme(cp) then
			table.insert(letters, str:sub(i, i + bytes - 1))
		end

		i = i + bytes
	end

	return table.concat(letters)
end

print(utf8_to_letters("a.-/bc2!ж日Zé😀")) -- prints: abcжZé
-- local s = "abcАБВ"
-- local lower = vim.lpeg.utfR(0x61, 0x7A)
-- local cyrillic = vim.lpeg.utfR(0x0410, 0x044F)
-- local letters = lower + cyrillic
--
-- local p = vim.lpeg.match(letters ^ 1, s) -- byte index after match
-- local matched = s:sub(1, p - 1)
-- print(matched) -- prints: abcАБВ
-- print(p) -- prints: 9 (total bytes for all matched chars)
-- -- print(string.match("abcé😀A", "%x*"))
-- decode UTF-8 string into a table of codepoints
-- local function utf8_to_codepoints(str)
-- 	local byte_num = 1
-- 	local total_bytes = #str
-- 	local codepoints = {}
--
-- 	while byte_num <= total_bytes do
-- 		local current_byte_decimal = str:byte(byte_num)
-- 		local cp
--
-- 		if current_byte_decimal < 0x80 then
-- 			-- 1-byte ASCII
-- 			cp = current_byte_decimal
-- 			byte_num = byte_num + 1
-- 		elseif current_byte_decimal < 0xE0 then
-- 			-- 2-byte sequence
-- 			local b2 = str:byte(byte_num + 1)
-- 			cp = ((current_byte_decimal % 0x20) * 0x40) + (b2 % 0x40)
-- 			byte_num = byte_num + 2
-- 		elseif current_byte_decimal < 0xF0 then
-- 			-- 3-byte sequence
-- 			local b2, b3 = str:byte(byte_num + 1, byte_num + 2)
-- 			cp = ((current_byte_decimal % 0x10) * 0x1000) + ((b2 % 0x40) * 0x40) + (b3 % 0x40)
-- 			byte_num = byte_num + 3
-- 		elseif current_byte_decimal < 0xF8 then
-- 			-- 4-byte sequence
-- 			local b2, b3, b4 = str:byte(byte_num + 1, byte_num + 3)
-- 			cp = ((current_byte_decimal % 0x08) * 0x40000) + ((b2 % 0x40) * 0x1000) + ((b3 % 0x40) * 0x40) + (b4 % 0x40)
-- 			byte_num = byte_num + 4
-- 		else
-- 			-- invalid UTF-8, skip 1 byte
-- 			cp = current_byte_decimal
-- 			byte_num = byte_num + 1
-- 		end
--
-- 		table.insert(codepoints, cp)
-- 	end
--
-- 	return codepoints
-- end
--
-- -- Example usage:
-- local s = "é😀A"
-- local cps = utf8_to_codepoints(s)
-- for _, cp in ipairs(cps) do
-- 	print(cp) -- prints: 233, 128512, 65
-- end
