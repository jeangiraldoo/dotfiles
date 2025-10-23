--- Display order is determined by the position of each severity in this table
--- Total count is displayed after the icon
local ENABLED_DIAGNOSTICS = {
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
}

local function count_diagnostics()
	local counts = {}

	for _, diagnostic_data in pairs(ENABLED_DIAGNOSTICS) do
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

return function(apply_highlight)
	local counts = count_diagnostics()

	local diagnostic_items = {}
	for _, diagnostic_data in ipairs(ENABLED_DIAGNOSTICS) do
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
