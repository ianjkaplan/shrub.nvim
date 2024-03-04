local actions = require("shrub.actions")
local default_config = require("shrub.config")
local M = {}

---@param action ShrubAction
local run = function(action)
    actions.run(
        action,
        vim.api.nvim_get_current_buf(),
        vim.treesitter.get_node()
    )
end

M.statement_block_surround = function()
    run("statement_block_surround")
end

M.statement_block_remove = function()
    run("statement_block_remove")
end

M.fun_declaration_to_arrow = function()
    run("fun_declaration_to_arrow")
end

M.arrow_fun_to_declaration = function()
    run("arrow_fun_to_declaration")
end

--- accepts a config table with a keys field to override default keybindings
--- @param config table | nil
M.setup = function(config)
    config = config or default_config
    for _, key in ipairs(config.keys or default_config.keys) do
        vim.api.nvim_set_keymap(unpack(key))
    end
end

return M
