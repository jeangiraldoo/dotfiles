--TODO rename SECTIONS fields so that it is clear they are assigned functions
local SECTIONS = {
	GIT = require("ui.statusline.git"),
	FILE = require("ui.statusline.file"),
	DIAGNOSTICS = require("ui.statusline.diagnostics"),
	POSITION = require("ui.statusline.position"),
}

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
		SECTIONS.GIT(apply_highlight),
		SECTIONS.FILE.status(file_name, apply_highlight),
	})

	local rigth_section = _build_section({
		SECTIONS.DIAGNOSTICS(apply_highlight),
		SECTIONS.FILE.metadata(file_name),
		SECTIONS.POSITION(apply_highlight),
	})

	return left_section .. "%=" .. rigth_section
end

return M
