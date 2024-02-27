local actions = require("shrub.actions")
local default_config = require("shrub.config")
local M = {}

--- TODO: do buffer specific setup here

M.statement_block_surround = function()
    actions.statement_block_surround(
        vim.api.nvim_get_current_buf(),
        vim.treesitter.get_node()
    )
end

M.statement_block_surround_undo = function()
    actions.statement_block_surround_undo(
        vim.api.nvim_get_current_buf(),
        vim.treesitter.get_node()
    )
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
