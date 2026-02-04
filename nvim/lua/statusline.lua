local utils = require("utils")

local RESET_HL = "%#StatusLine#" -- Used to reset/close any active highlights

local SECTION_STYLES = {
	GIT = {
		CONTAINER = {
			MAIN_HIGHLIGHT = {
				name = "StatusLineGitContainer",
				data = {
					bg = "#d79921",
				},
			},
		},
		TEXT = {
			MAIN_HIGHLIGHT = {
				name = "StatusLineGitText",
				data = {
					fg = "#d79921",
					bg = "#1e2030",
				},
			},
		},
		ICON = {
			MAIN_HIGHLIGHT = {
				name = "StatusLineGitIcon",
				data = {
					fg = "#d79921",
					bg = "#b84500",
				},
			},
		},
	},
	POSITION = {
		LAYOUT = "%s█",
		CONTAINER = {
			MAIN_HIGHLIGHT = {
				name = "StatusLinePositionContainer",
				data = {
					bg = "#d79921",
				},
			},
		},
		TEXT = {
			MAIN_HIGHLIGHT = {
				name = "StatusLinePositionText",
				data = {
					bg = "#1e2030",
					fg = "#d79921",
				},
			},
			HIGHLIGHTS = {
				["StatusLinePositionContainer"] = {
					bg = "#d79921",
				},
			},
		},
	},
}
SECTION_STYLES.GIT.LAYOUT = "█%%#" .. SECTION_STYLES.GIT.ICON.MAIN_HIGHLIGHT.name .. "# %s█%" .. RESET_HL

for _, section in pairs(SECTION_STYLES) do
	for section_part_name, section_part_data in pairs(section) do
		if section_part_name ~= "LAYOUT" then
			utils.editor.set_highlights({
				[section_part_data.MAIN_HIGHLIGHT.name] = section_part_data.MAIN_HIGHLIGHT.data,
			})

			if section_part_data.HIGHLIGHTS then
				utils.editor.set_highlights(section_part_data.HIGHLIGHTS)
			end
		end
	end
end

local function build_block_string(name, content)
	local section_style = SECTION_STYLES[name]
	local container_hl = "%#" .. section_style.CONTAINER.MAIN_HIGHLIGHT.name .. "#"
	local text = "%#" .. section_style.TEXT.MAIN_HIGHLIGHT.name .. "#" .. content .. container_hl
	return container_hl .. string.format(section_style.LAYOUT, text)
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

local function _build_file()
	local file_name = vim.fn.expand("%:t")

	if file_name == "" then
		return RESET_HL .. "[No name]"
	end

	local items = {
		vim.fs.joinpath(vim.fs.basename(vim.fs.dirname(vim.api.nvim_buf_get_name(0))), file_name),
		vim.bo.modified and "%#WhiteText#●" or "",
	}

	return table.concat(items, " ")
end

local POSITION = build_block_string("POSITION", "󰆌  %l:%c | %p%%")

return function()
	local statusline_str = table.concat({
		build_block_string("GIT", (vim.b.gitsigns_head or "[No Branch]")),
		_build_file(),
		"%=",
		Diagnostics.build(),
		POSITION,
	}, " ")

	return statusline_str
end
