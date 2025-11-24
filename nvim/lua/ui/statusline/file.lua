local Metadata = {
	READONLY_ICON = " ",
	NEWLINE_CHARS = {
		unix = "LF",
		dos = "CRLF",
		mac = "CR",
	},
}

function Metadata.build(file_name)
	local items = {}
	if vim.bo.readonly then
		table.insert(items, Metadata.READONLY_ICON)
	end

	if file_name ~= "" then
		table.insert(items, Metadata.NEWLINE_CHARS[vim.bo.fileformat])
	end

	table.insert(items, vim.bo.fileencoding:upper())

	return table.concat(items, " ")
end

local Status = {
	FILE_ICONS = require("ui.statusline._filetype_styles"),
	MODIFIED = {
		ICON = "●",
		HL_NAME = "WhiteText",
	},
	BUFFER_NO_NAME = "[No Name]",
	BUFFER_MODIFIED_ICON = nil, -- Built once at startup from ´MODIFIED´ fields and cached
}

function Status.genereate_buffer_modified_icon(apply_highlight)
	Status.BUFFER_MODIFIED_ICON = apply_highlight({
		hl_name = Status.MODIFIED.HL_NAME,
		text = Status.MODIFIED.ICON,
		should_reset = true,
	})
end

function Status.build_file_path_and_icon(file_name, apply_highlight)
	if file_name == "" then
		return apply_highlight({
			text = Status.BUFFER_NO_NAME,
		})
	end

	local filetype = vim.bo.filetype

	local new_icon_data = Status.FILE_ICONS[filetype] or Status.FILE_ICONS.text

	local parent_dir = vim.fn.expand("%:p:h:t")
	local path = vim.fs.joinpath(parent_dir, file_name)

	local new_icon, icon_color = new_icon_data.ICON, new_icon_data.HIGHLIGHT

	local hl_name = "StatusLineDevIcon" .. filetype
	local hl_exists = vim.fn.hlexists(hl_name) == 1

	if icon_color and not hl_exists then
		vim.api.nvim_set_hl(0, hl_name, { fg = icon_color })
	end

	local coloured_icon = apply_highlight({
		hl_name = hl_name,
		text = new_icon,
		should_reset = true,
	})
	return path, coloured_icon
end

function Status.build(file_name, apply_highlight)
	if not Status.BUFFER_MODIFIED_ICON then
		Status.genereate_buffer_modified_icon(apply_highlight)
	end
	local items = {}
	local file_path, icon = Status.build_file_path_and_icon(file_name, apply_highlight)

	if icon then
		table.insert(items, icon)
	end

	table.insert(items, file_path)

	if vim.bo.modified then
		table.insert(items, Status.BUFFER_MODIFIED_ICON)
	end

	return table.concat(items, " ")
end

return {
	metadata = Metadata.build,
	status = Status.build,
}
