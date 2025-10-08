local utils = require("utils")
local KEYMAPS = utils.module.fetch_join_tables("keymaps")

utils.editor.set_keymaps(KEYMAPS)
