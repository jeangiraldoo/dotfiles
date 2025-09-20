local utils = require("utils")
local plugin_specs = utils.get_combined_module_tbls("plugins")

vim.pack.add(plugin_specs, {
	confirm = false,
	load = function(plugin)
		local spec = plugin.spec or {}
		local spec_data = spec.data
		if not spec_data then
			return
		end

		-- Specs are disabled by default unless explicitly enabled.
		-- This keeps plugin specifications clear and avoids hidden magic.
		if not spec_data.enabled then
			return
		end

		-- Customizing a plugin inside another plugin's dependency list is error-prone,
		-- since every reference would need to stay in sync with the customization.
		-- To avoid bugs, plugins that require customization should be defined in their
		-- own spec file instead.
		local dependencies = spec_data.dependencies
		if dependencies then
			vim.pack.add(dependencies, { confirm = false, load = true })
		end

		vim.cmd.packadd(spec.name)

		if spec.data and spec.data.setup ~= nil then
			spec.data.setup()
		end
	end,
})
