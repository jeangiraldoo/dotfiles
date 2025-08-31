local utils = require("utils")
local raw_plugin_specs = utils.get_combined_module_tables("plugins")

local PROVIDER_URL = {
	github = "https://github.com",
	gitlab = "https://gitlab.com",
	bitbucket = "https://bitbucket.org",
}

local DEFAULT_PROVIDER = "github"
local PLUGIN_URL_TEMPLATE = "%s/%s/%s"

local function setup_plugins(plugin_opts)
	for module_name, config in pairs(plugin_opts) do
		print(module_name, type(config))
		if type(config) == "function" then
			config()
			goto continue
		end

		local success, module = pcall(require, module_name)
		if not success then
			goto continue
		end

		local setup = module.setup
		if setup then
			setup(config)
		end

		::continue::
	end
end

local function build_pack_entry(spec)
	--- Defaults to enabled unless explicitely set to false
	if spec.enabled == false then
		return nil
	end

	local provider = spec.provider or DEFAULT_PROVIDER

	--- Most plugins use ".nvim" as a repository suffix,
	--- so this adds it unless explicitly disabled in the spec
	local repo_name = spec.remove_name_suffix and spec.name or (spec.name .. ".nvim")
	local url = PLUGIN_URL_TEMPLATE:format(PROVIDER_URL[provider], spec.author, repo_name)

	return {
		src = url,
		name = spec.name,
		version = spec.version,
	}
end

local function add_plugin_config_entry(spec, config_entries)
	local require_name = spec.require_name or spec.name
	local config = spec.config or spec.opts

	config_entries[require_name] = config
end

local function build_plugin_specs_and_opts()
	local pack_specs = {}
	local plugin_opts = {}
	local dependency_specs = {}

	for _, spec in ipairs(raw_plugin_specs) do
		local entry = build_pack_entry(spec)
		if not entry then
			goto continue
		end

		table.insert(pack_specs, entry)
		add_plugin_config_entry(spec, plugin_opts)

		local dependencies = spec.dependencies
		if dependencies then
			for _, dependency_spec in pairs(dependencies) do
				table.insert(dependency_specs, dependency_spec)
			end
		end

		::continue::
	end

	return pack_specs, plugin_opts, dependency_specs
end

local plugin_specs, plugin_opts, dependency_specs = build_plugin_specs_and_opts()

print("OPts: ", vim.inspect(plugin_opts))
print("Original specs: ", vim.inspect(plugin_specs))

local dependencies_without_full_spec = {}

for _, dependency in ipairs(dependency_specs) do
	local found = false
	for _, plugin_spec in ipairs(plugin_specs) do
		if plugin_spec.name == dependency.name then
			found = true
			break
		end
	end
	if not found then
		local entry = build_pack_entry(dependency)
		table.insert(dependencies_without_full_spec, entry)
	end
end

local specs = vim.list_extend(vim.deepcopy(plugin_specs), dependencies_without_full_spec)
print("Depend: ", vim.inspect(dependencies_without_full_spec))
print("Specs: ", vim.inspect(specs))

-- vim.pack.add(plugin_specs)
vim.pack.add(specs, { confirm = false, load = true })
-- for _, spec in ipairs(specs) do
-- 	print("added " .. spec.name)
-- 	vim.cmd("packadd " .. spec.name)
-- end
setup_plugins(plugin_opts)
