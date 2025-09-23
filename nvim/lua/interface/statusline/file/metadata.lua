local NEWLINE_CHARS = {
	unix = "LF",
	dos = "CRLF",
	mac = "CR",
}

local READONLY_ICON = " "

return function(file_name)
	local items = {}
	if vim.bo.readonly then
		table.insert(items, READONLY_ICON)
	end

	if file_name ~= "" then
		table.insert(items, NEWLINE_CHARS[vim.bo.fileformat])
	end

	table.insert(items, vim.bo.fileencoding:upper())

	return table.concat(items, " ")
end
