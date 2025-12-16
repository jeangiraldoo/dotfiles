local utils = require("utils")

---@class PluginSpec
---@field src string
---@field data {
---     enabled: boolean,
---     setup: fun(),
---     dependencies?: table[],
---     keymaps?: table[] }

---@type PluginSpec[]
local plugin_specs = utils.module.require_config_tables("plugins")

-- Defined separately from plugin specs because vim.pack.add throws an error otherwise
local BUILTIN_PLUGINS = {
	"nvim.undotree",
}

for _, plugin_name in ipairs(BUILTIN_PLUGINS) do
	vim.cmd("packadd " .. plugin_name)
end

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

		if spec.data.keymaps then
			utils.editor.set_keymaps(spec.data.keymaps)
		end
	end,
})
