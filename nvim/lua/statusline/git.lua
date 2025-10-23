--- Git content surrounded by highlighted blocks
local LAYOUT = {
	FORMAT = "%s█%s%s█",
	HL_NAME = "StatusLineGitContainer",
}

local TITLE_SECTION = {
	GIT_ICON = {
		CHAR = "",
		HL_NAME = "StatusLineGitIcon",
	},
	TEXT = {
		NO_BRANCH = "[No Branch]",
		HL_NAME = "StatusLineGitText",
	},
}

--- The order of entries in this table defines the display order in the statusline
local STATUS_SECTION_ITEMS = {
	{
		TYPE = "added",
		HL_NAME = "StatusLineGitAdded",
		ICON = "+",
	},
	{
		TYPE = "changed",
		HL_NAME = "StatusLineGitChanged",
		ICON = "~",
	},
	{
		TYPE = "removed",
		HL_NAME = "StatusLineGitRemoved",
		ICON = "-",
	},
}

--- Generated at startup from constants and cached, since they remain static
local GIT_ICON
local CONTAINER_HL

local function add_status_items(items_acc, apply_highlight)
	local git_status = vim.b.gitsigns_status_dict or {}
	for _, status_data in ipairs(STATUS_SECTION_ITEMS) do
		local status_type_icon = apply_highlight({
			hl_name = status_data.HL_NAME,
			text = status_data.ICON,
		})

		local total = git_status[status_data.TYPE] or 0

		if total > 0 then
			table.insert(items_acc, status_type_icon .. total)
		end
	end
end

local function build_branch_name(apply_highlight)
	local title = vim.b.gitsigns_head or TITLE_SECTION.TEXT.NO_BRANCH
	local highlighted_title = apply_highlight({
		hl_name = TITLE_SECTION.TEXT.HL_NAME,
		text = title,
	})

	return highlighted_title
end

return function(apply_highlight)
	if not CONTAINER_HL then
		CONTAINER_HL = apply_highlight({
			hl_name = LAYOUT.HL_NAME,
		})
	end

	if not GIT_ICON then
		GIT_ICON = apply_highlight({
			hl_name = TITLE_SECTION.GIT_ICON.HL_NAME,
			text = TITLE_SECTION.GIT_ICON.CHAR,
		})
	end

	local items = {
		GIT_ICON,
		build_branch_name(apply_highlight),
	}

	add_status_items(items, apply_highlight)

	local content = table.concat(items, " ")

	return LAYOUT.FORMAT:format(CONTAINER_HL, content, CONTAINER_HL)
end
