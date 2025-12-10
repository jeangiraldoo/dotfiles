local FILE_ICONS = require("ui._filetype_styles")

local RESET_HL = "%#StatusLine#" -- Used to reset/close any active highlights

local function apply_highlight(data)
	local function create_highlight(name)
		return string.format("%%#%s#", name)
	end

	local text = data.text
	local highlight_name = data.hl_name

	if text then
		local highlighted_text = create_highlight(highlight_name or RESET_HL_NAME) .. text

		if not data.should_reset then
			return highlighted_text
		end

		return highlighted_text .. RESET_HL
	end

	if highlight_name then
		return create_highlight(highlight_name)
	end
local function build_block(block_char_pair, hl, content)
	local block_structure = "%s" .. block_char_pair[1] .. "%s%s" .. block_char_pair[2]
	return string.format(block_structure, hl, content, hl)
end

local Diagnostics = {
	TYPES = {
		[vim.diagnostic.severity.ERROR] = "%#DiagnosticError#" .. RESET_HL,
		[vim.diagnostic.severity.WARN] = "%#DiagnosticWarn#" .. RESET_HL,
		[vim.diagnostic.severity.INFO] = "%#DiagnosticInfo#" .. RESET_HL,
		[vim.diagnostic.severity.HINT] = "%#DiagnosticHint#" .. RESET_HL,
	},
}

function Diagnostics.build()
	local diagnostic_items = {}
	for severity_type, icon in pairs(Diagnostics.TYPES) do
		local severity_count = #vim.diagnostic.get(0, { severity = severity_type })

		local diagnostic_item = icon .. severity_count
		table.insert(diagnostic_items, diagnostic_item)
	end

	return table.concat(diagnostic_items, " ")
end

local File = {
	BUFFER_MODIFIED_ICON = "%#WhiteText#●",
	UNNAMED_BUFFER = RESET_HL .. "[No name]",
	FILETYPE_ICON_HL = {
		BASE_NAME = "StatusLineDevIcon",
	},
}
File.FILETYPE_ICON_HL["STRUCTURE"] = "%%#" .. File.FILETYPE_ICON_HL.BASE_NAME .. "%s#"

function File.build()
	local file_name = vim.fn.expand("%:t")

	if file_name == "" then
		return File.UNNAMED_BUFFER
	end

	local new_icon_data = FILE_ICONS[vim.bo.filetype] or FILE_ICONS.text

	local hl_name = File.FILETYPE_ICON_HL.BASE_NAME .. vim.bo.filetype
	local icon_color = new_icon_data.HIGHLIGHT
	if icon_color and vim.fn.hlexists(hl_name) == 0 then
		vim.api.nvim_set_hl(0, hl_name, { bg = icon_color })
	end

	local items = {
		File.FILETYPE_ICON_HL.STRUCTURE:format(vim.bo.filetype) .. new_icon_data.ICON .. RESET_HL,
		vim.fs.joinpath(vim.fs.basename(vim.fs.dirname(vim.api.nvim_buf_get_name(0))), file_name),
		vim.bo.modified and File.BUFFER_MODIFIED_ICON or "",
	}

	return table.concat(items, " ")
end

local Git = {
	ICON = "%#StatusLineGitIcon#",
	CONTAINER_HL = "%#StatusLineGitContainer#",
	BRANCH_NAME_HL = "%#StatusLineGitText#",
	NO_BRANCH_TEXT = "[No Branch]",
}

function Git.build()
	local branch_text = Git.BRANCH_NAME_HL .. (vim.b.gitsigns_head or Git.NO_BRANCH_TEXT)
	local content = Git.ICON .. " " .. branch_text
	return build_block({ "█", "█" }, Git.CONTAINER_HL, content)
end

--- The entire ´position´ section is static, so it only needs to be built once
local POSITION_CACHE = (function()
	local container_hl = "%#StatusLineLocationContainer#"
	local content = "󰆌  %l:%c | %p%%"

	local highlighted_text = "%#StatusLinePositionText#" .. content
	return build_block({ "", "█" }, container_hl, highlighted_text)
end)()

return function()
	local statusline_str = table.concat({
		Git.build(),
		File.build(),
		"%=",
		Diagnostics.build(apply_highlight),
		POSITION_CACHE,
	}, " ")

	return statusline_str
end
