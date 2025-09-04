--- Position content surrounded by highlighted blocks
local LAYOUT = {
	STRUCTURE = "%s%s%s█",
	HL_NAME = "StatusLineLocationContainer",
}

local ICON = "󰆌"
local ITEMS = "%l:%c | %p%%"
local TEXT_HL_NAME = "StatusLinePositionText"

--- The entire ´position´ section is static, so it only needs to be built once
local CACHED_SECTION

return function(apply_highlight)
	if not CACHED_SECTION then
		local container_hl = apply_highlight({
			hl_name = LAYOUT.HL_NAME,
		})

		local content = ICON .. " " .. ITEMS

		local highlighted_text = apply_highlight({
			hl_name = TEXT_HL_NAME,
			text = content,
		})

		CACHED_SECTION = LAYOUT.STRUCTURE:format(container_hl, highlighted_text, container_hl)
	end

	return CACHED_SECTION
end
