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
end

local Diagnostics = {
	TYPES = {
		[vim.diagnostic.severity.ERROR] = "%#DiagnosticError#" .. RESET_HL,
		[vim.diagnostic.severity.WARN] = "%#DiagnosticWarn#" .. RESET_HL,
		[vim.diagnostic.severity.INFO] = "%#DiagnosticInfo#" .. RESET_HL,
		[vim.diagnostic.severity.HINT] = "%#DiagnosticHint#" .. RESET_HL,
	}
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
	BUFFER_MODIFIED_ICON = apply_highlight({
		hl_name = "WhiteText",
		text = "●",
		should_reset = true,
	}),
	UNNAMED_BUFFER = "[No name]",
}


function File.build_data(file_name)
	local function build_path_and_icon()
		if file_name == "" then
			return apply_highlight({
				text = File.UNNAMED_BUFFER,
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
			vim.api.nvim_set_hl(0, hl_name, { bg = icon_color })
		end

		local coloured_icon = apply_highlight({
			hl_name = hl_name,
			text = new_icon,
			should_reset = true,
		})
		return path, coloured_icon
	end

	local items = {}
	local file_path, icon = build_path_and_icon()

	if icon then
		table.insert(items, icon)
	end

	table.insert(items, file_path)

	if vim.bo.modified then
		table.insert(items, File.BUFFER_MODIFIED_ICON)
	end

	return table.concat(items, " ")
end

local Git = {
	ICON = apply_highlight({
		hl_name = "StatusLineGitIcon",
		text = "",
	}),
	CONTAINER_HL = apply_highlight({
		hl_name = "StatusLineGitContainer",
	}),
	NO_BRANCH_TEXT = "[No Branch]",
}

function Git.build()
	local function build_branch_name()
		return apply_highlight({
			hl_name = "StatusLineGitText",
			text = vim.b.gitsigns_head or Git.NO_BRANCH_TEXT,
		})
	end

	local section_parts = {
		Git.ICON,
		build_branch_name(),
	}

	local section_text = table.concat(section_parts, " ")

	return string.format("%s█%s%s█", Git.CONTAINER_HL, section_text, Git.CONTAINER_HL)
end

--- The entire ´position´ section is static, so it only needs to be built once
local POSITION_CACHE = (function()
	local container_hl = apply_highlight({
		hl_name = "StatusLineLocationContainer",
	})

	local highlighted_text = apply_highlight({
		hl_name = "StatusLinePositionText",
		text = "󰆌  %l:%c | %p%%",
	})

	return string.format("%s%s%s█", container_hl, highlighted_text, container_hl)
end)()

return function()
	local file_name = vim.fn.expand("%:t")

	local statusline_str = table.concat({
		Git.build(apply_highlight),
		File.build_data(file_name),
		"%=",
		Diagnostics.build(apply_highlight),
		POSITION_CACHE,
	}, " ")

	return statusline_str
end
