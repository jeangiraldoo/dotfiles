local devicons = require("nvim-web-devicons")

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

	local parent_dir = vim.fn.expand("%:p:h:t")
	local extension = vim.fn.expand("%:e")

	local icon, color = devicons.get_icon_color(file_name, extension, { default = true })

	local hl_name = "StatusLineDevIcon" .. extension
	local hl_exists = vim.fn.hlexists(hl_name) == 1

	if color and not hl_exists then
		vim.api.nvim_set_hl(0, hl_name, { fg = color })
	end

	local path = vim.fs.joinpath(parent_dir, file_name)

	if not icon then
		return path
	end

	local coloured_icon = apply_highlight({
		hl_name = hl_name,
		text = icon,
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
