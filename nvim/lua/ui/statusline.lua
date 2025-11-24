--- Display order is determined by the position of each severity in this table
--- Total count is displayed after the icon
local Diagnostics = {
	ENABLED_DIAGNOSTICS = {
		{
			TYPE = vim.diagnostic.severity.ERROR,
			ICON = "",
			HL_NAME = "DiagnosticError",
		},
		{
			TYPE = vim.diagnostic.severity.WARN,
			ICON = "",
			HL_NAME = "DiagnosticWarn",
		},
		{
			TYPE = vim.diagnostic.severity.INFO,
			ICON = "",
			HL_NAME = "DiagnosticInfo",
		},
		{
			TYPE = vim.diagnostic.severity.HINT,
			ICON = "",
			HL_NAME = "DiagnosticHint",
		},
	},
}

function Diagnostics.count_diagnostics()
	local counts = {}

	for _, diagnostic_data in pairs(Diagnostics.ENABLED_DIAGNOSTICS) do
		counts[diagnostic_data.TYPE] = 0
	end

	for _, diagnostic in ipairs(vim.diagnostic.get(0)) do
		local severity_type = diagnostic.severity
		local severity_count = counts[severity_type]
		if severity_count then
			counts[severity_type] = severity_count + 1
		end
	end

	return counts
end

function Diagnostics.build(apply_highlight)
	local counts = Diagnostics.count_diagnostics()

	local diagnostic_items = {}
	for _, diagnostic_data in ipairs(Diagnostics.ENABLED_DIAGNOSTICS) do
		local severity_count = counts[diagnostic_data.TYPE]
		if severity_count > 0 then
			local coloured_icon = apply_highlight({
				hl_name = diagnostic_data.HL_NAME,
				text = diagnostic_data.ICON,
				should_reset = true,
			})
			local diagnostic_item = coloured_icon .. " " .. severity_count
			table.insert(diagnostic_items, diagnostic_item)
		end
	end

	return table.concat(diagnostic_items, " ")
end

local File = {
	Metadata = {
		READONLY_ICON = " ",
		NEWLINE_CHARS = {
			unix = "LF",
			dos = "CRLF",
			mac = "CR",
		},
	},
	Status = {
		FILE_ICONS = require("ui._filetype_styles"),
		MODIFIED = {
			ICON = "●",
			HL_NAME = "WhiteText",
		},
		BUFFER_NO_NAME = "[No Name]",
		BUFFER_MODIFIED_ICON = nil, -- Built once at startup from ´MODIFIED´ fields and cached
	},
}

function File.Metadata.build(file_name)
	local items = {}
	if vim.bo.readonly then
		table.insert(items, File.Metadata.READONLY_ICON)
	end

	if file_name ~= "" then
		table.insert(items, File.Metadata.NEWLINE_CHARS[vim.bo.fileformat])
	end

	table.insert(items, vim.bo.fileencoding:upper())

	return table.concat(items, " ")
end

function File.Status.genereate_buffer_modified_icon(apply_highlight)
	File.Status.BUFFER_MODIFIED_ICON = apply_highlight({
		hl_name = File.Status.MODIFIED.HL_NAME,
		text = File.Status.MODIFIED.ICON,
		should_reset = true,
	})
end

function File.Status.build_file_path_and_icon(file_name, apply_highlight)
	if file_name == "" then
		return apply_highlight({
			text = File.Status.BUFFER_NO_NAME,
		})
	end

	local filetype = vim.bo.filetype

	local new_icon_data = File.Status.FILE_ICONS[filetype] or File.Status.FILE_ICONS.text

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

function File.Status.build(file_name, apply_highlight)
	if not File.Status.BUFFER_MODIFIED_ICON then
		File.Status.genereate_buffer_modified_icon(apply_highlight)
	end
	local items = {}
	local file_path, icon = File.Status.build_file_path_and_icon(file_name, apply_highlight)

	if icon then
		table.insert(items, icon)
	end

	table.insert(items, file_path)

	if vim.bo.modified then
		table.insert(items, File.Status.BUFFER_MODIFIED_ICON)
	end

	return table.concat(items, " ")
end

local Git = {
	TITLE_SECTION = {
		GIT_ICON = {
			CHAR = "",
			HL_NAME = "StatusLineGitIcon",
		},
		TEXT = {
			NO_BRANCH = "[No Branch]",
			HL_NAME = "StatusLineGitText",
		},
	},
	--- The order of entries in this table defines the display order in the statusline
	STATUS_SECTION_ITEMS = {
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
	},
	--- Git content surrounded by highlighted blocks
	LAYOUT = {
		FORMAT = "%s█%s%s█",
		HL_NAME = "StatusLineGitContainer",
	},
}

--- Generated at startup from constants and cached, since they remain static
local GIT_ICON
local CONTAINER_HL

function Git.add_status_items(items_acc, apply_highlight)
	local git_status = vim.b.gitsigns_status_dict or {}
	for _, status_data in ipairs(Git.STATUS_SECTION_ITEMS) do
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

function Git.build_branch_name(apply_highlight)
	local title = vim.b.gitsigns_head or Git.TITLE_SECTION.TEXT.NO_BRANCH
	local highlighted_title = apply_highlight({
		hl_name = Git.TITLE_SECTION.TEXT.HL_NAME,
		text = title,
	})

	return highlighted_title
end

function Git.build(apply_highlight)
	if not CONTAINER_HL then
		CONTAINER_HL = apply_highlight({
			hl_name = Git.LAYOUT.HL_NAME,
		})
	end

	if not GIT_ICON then
		GIT_ICON = apply_highlight({
			hl_name = Git.TITLE_SECTION.GIT_ICON.HL_NAME,
			text = Git.TITLE_SECTION.GIT_ICON.CHAR,
		})
	end

	local items = {
		GIT_ICON,
		Git.build_branch_name(apply_highlight),
	}

	Git.add_status_items(items, apply_highlight)

	local content = table.concat(items, " ")

	return Git.LAYOUT.FORMAT:format(CONTAINER_HL, content, CONTAINER_HL)
end

local Position = {
	ICON = "󰆌",
	ITEMS = "%l:%c | %p%%",
	TEXT_HL_NAME = "StatusLinePositionText",
	LAYOUT = {
		STRUCTURE = "%s%s%s█",
		HL_NAME = "StatusLineLocationContainer",
	},
}
--- Position content surrounded by highlighted blocks

--- The entire ´position´ section is static, so it only needs to be built once
local CACHED_SECTION

function Position.build(apply_highlight)
	if not CACHED_SECTION then
		local container_hl = apply_highlight({
			hl_name = Position.LAYOUT.HL_NAME,
		})

		local content = Position.ICON .. " " .. Position.ITEMS

		local highlighted_text = apply_highlight({
			hl_name = Position.TEXT_HL_NAME,
			text = content,
		})

		CACHED_SECTION = Position.LAYOUT.STRUCTURE:format(container_hl, highlighted_text, container_hl)
	end

	return CACHED_SECTION
end

local PATTERNS = {
	highlight_group = "%%#%s#",
}

--- Highlight group used to reset/close any active highlights
local RESET_HL_NAME = "StatusLine"
local RESET = PATTERNS.highlight_group:format(RESET_HL_NAME)

local M = {}

local function apply_highlight(data)
	local text = data.text
	local highlight_name = data.hl_name
	local should_reset = data.should_reset

	if text then
		local highlighted_text = PATTERNS.highlight_group:format(highlight_name or RESET_HL_NAME) .. text

		if not should_reset then
			return highlighted_text
		end

		return highlighted_text .. RESET
	end

	if highlight_name then
		return PATTERNS.highlight_group:format(highlight_name)
	end
end

local function _build_section(section_items)
	return table.concat(section_items, " ")
end

function M.build_statusline()
	local file_name = vim.fn.expand("%:t")

	local left_section = _build_section({
		Git.build(apply_highlight),
		File.Status.build(file_name, apply_highlight),
	})

	local rigth_section = _build_section({
		Diagnostics.build(apply_highlight),
		File.Metadata.build(file_name),
		Position.build(apply_highlight),
	})

	return left_section .. "%=" .. rigth_section
end

return M
