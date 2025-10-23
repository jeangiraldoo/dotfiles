local FILE_ICONS = require("statusline.file._filetype_styles")

local MODIFIED = {
	ICON = "●",
	HL_NAME = "WhiteText",
}

--- Built once at startup from ´MODIFIED´ fields and cached
local BUFFER_MODIFIED_ICON

local BUFFER_NO_NAME = "[No Name]"

local function genereate_buffer_modified_icon(apply_highlight)
	BUFFER_MODIFIED_ICON = apply_highlight({
		hl_name = MODIFIED.HL_NAME,
		text = MODIFIED.ICON,
		should_reset = true,
	})
end

local function build_file_path_and_icon(file_name, apply_highlight)
	if file_name == "" then
		return apply_highlight({
			text = BUFFER_NO_NAME,
		})
	end

	local filetype = vim.bo.filetype

	local new_icon_data = FILE_ICONS[filetype] or FILE_ICONS.text

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

return function(file_name, apply_highlight)
	if not BUFFER_MODIFIED_ICON then
		genereate_buffer_modified_icon(apply_highlight)
	end
	local items = {}
	local file_path, icon = build_file_path_and_icon(file_name, apply_highlight)

	if icon then
		table.insert(items, icon)
	end

	table.insert(items, file_path)

	if vim.bo.modified then
		table.insert(items, BUFFER_MODIFIED_ICON)
	end

	return table.concat(items, " ")
end
