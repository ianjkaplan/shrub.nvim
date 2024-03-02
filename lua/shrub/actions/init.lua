local utils = require("shrub.utils")

local M = {
    _ft = "typescript",
}

--- register a new action as config
---@type table<ShrubAction, ShrubActionConfig>
local shrub_actions = {
    statement_block_surround = require(
        "shrub.actions.statement_block_surround"
    ),
    statement_block_remove = require("shrub.actions.statement_block_remove"),
    fun_declaration_to_arrow = require(
        "shrub.actions.fun_declaration_to_arrow"
    ),
    arrow_fun_to_declaration = require(
        "shrub.actions.arrow_fun_to_declaration"
    ),
}

--- Runs a shrub action
---@param action ShrubAction
---@param bufnr integer
---@param node TSNode|nil if no node is provided will use the closest node to the cursor
---@return boolean True the action updated the buffer, false otherise
M.run = function(action, bufnr, node)
    local config = shrub_actions[action]
    M._ft = vim.bo[bufnr].filetype

    if not utils.check_filetype(M._ft) then
        error("shrub: filetype not supported", vim.log.levels.ERROR)
        return false
    end

    if node == nil then
        node = vim.treesitter.get_node()
    end

    if node == nil then
        error("shrub: no node found", vim.log.levels.ERROR)
        return false
    end

    if not utils.check_filetype(M._ft) then
        error("shrub: filetype not supported", vim.log.levels.ERROR)
    end

    node = utils.find_nearest_parent_ts_node(node, config.root_node_type)
    if node == nil then
        return false
    end

    local query = vim.treesitter.query.parse(M._ft, config.query)

    local captures = {}
    for id, current_node in query:iter_captures(node, bufnr, 0, -1) do
        local name = query.captures[id]
        captures[name] = current_node
    end

    config.handle_captures(captures, bufnr)
    return true
end

return M
