local Module = {}

local function _is_valid_lua_file(file_name)
	local is_lua = file_name:sub(-4) == ".lua"
	local is_init = file_name == "init.lua"
	return is_lua and not is_init
end

function Module.fetch_join_tables(dir)
	local full_path = vim.fn.stdpath("config") .. "/lua/" .. dir:gsub("%.", "/")
	local dir_files = vim.fn.readdir(full_path)

	local combined_entries = vim.iter(dir_files)
		:filter(function(file_name)
			return _is_valid_lua_file(file_name)
		end)
		:fold({}, function(acc, file_name)
			local file_relative_path = dir .. "." .. file_name:gsub("%.lua$", "")

			local ok, file_tbl = pcall(require, file_relative_path)
			if not ok then
				vim.notify("Failed to load " .. file_relative_path, vim.log.levels.WARN)
				return acc
			end

			if vim.islist(file_tbl) then
				return vim.list_extend(acc, file_tbl)
			end

			table.insert(acc, file_tbl)
			return acc
		end)

	return combined_entries
end

return Module
