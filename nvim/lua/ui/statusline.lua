local utils = require("utils")

local RESET_HL = "%#StatusLine#" -- Used to reset/close any active highlights

local function build_block(block_char_pair, hl, content)
	local block_structure = "%s" .. block_char_pair[1] .. "%s%s" .. block_char_pair[2]
	return string.format(block_structure, hl, content, hl) .. RESET_HL
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

	local items = {
		vim.fs.joinpath(vim.fs.basename(vim.fs.dirname(vim.api.nvim_buf_get_name(0))), file_name),
		vim.bo.modified and File.BUFFER_MODIFIED_ICON or "",
	}

	return table.concat(items, " ")
end

local Git = {
	ICON = {
		VALUE = "",
		COLOUR = "#b84500",
		HL_NAME = "StatusLineGitIcon",
	},
	CONTAINER = {
		HL_NAME = "StatusLineGitContainer",
		COLOUR = "#d79921",
	},
	TEXT = {
		HL_NAME = "StatusLineGitText",
		NO_BRANCH = "[No Branch]",
		COLOUR = "#1e2030",
	},
}

utils.editor.set_highlights({
	[Git.ICON.HL_NAME] = {
		bg = Git.ICON.COLOUR,
		fg = Git.CONTAINER.COLOUR,
	},
	[Git.TEXT.HL_NAME] = {
		fg = Git.CONTAINER.COLOUR,
		bg = Git.TEXT.COLOUR,
	},
	[Git.CONTAINER.HL_NAME] = {
		bg = Git.CONTAINER.COLOUR,
	},
})

function Git.build()
	local branch_text = "%#" .. Git.TEXT.HL_NAME .. "#" .. (vim.b.gitsigns_head or Git.TEXT.NO_BRANCH)
	local content = "%#" .. Git.ICON.HL_NAME .. "#" .. Git.ICON.VALUE .. " " .. branch_text
	return build_block({ "█", "█" }, "%#" .. Git.CONTAINER.HL_NAME .. "#", content)
end

--- The entire ´position´ section is static, so it only needs to be built once
local POSITION_CACHE = (function()
	local OPTS = {
		TEXT = {
			COLOUR = "#1e2030",
			HL_NAME = "StatusLinePositionText",
		},
		CONTAINER = {
			COLOUR = "#d79921",
			HL_NAME = "StatusLinePositionContainer",
		},
	}

	utils.editor.set_highlights({
		[OPTS.TEXT.HL_NAME] = {
			bg = OPTS.TEXT.COLOUR,
			fg = OPTS.CONTAINER.COLOUR,
		},
		[OPTS.CONTAINER.HL_NAME] = {
			bg = OPTS.CONTAINER.COLOUR,
		},
	})

	local container_hl = "%#" .. OPTS.CONTAINER.HL_NAME .. "#"
	local content = "󰆌  %l:%c | %p%%"

	return build_block({ "", "█" }, container_hl, "%#" .. OPTS.TEXT.HL_NAME .. "#" .. content)
end)()

return function()
	local statusline_str = table.concat({
		Git.build(),
		File.build(),
		"%=",
		Diagnostics.build(),
		POSITION_CACHE,
	}, " ")

	return statusline_str
end
