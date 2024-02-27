local utils = require("shrub.utils")
local M = {}

--- If node is nil, it will use the current node
---@param node TSNode|nil
M._get_current_node = function(node)
    if node == nil then
        node = vim.treesitter.get_node()
    end
    if node == nil then
        error("shrub: no node found", vim.log.levels.ERROR)
        return nil
    end
    return node
end
--- Surrounds the current node with a statement block
--- Used for arrow functions and if statements
--- @param bufnr integer
--- @param node TSNode|nil
--- @return boolean True the action updated the buffer, false otherwise
M.statement_block_surround = function(bufnr, node)
    node = M._get_current_node(node)

    local ft = vim.bo[bufnr].filetype
    if not utils.check_filetype(ft) then
        error("shrub: filetype not supported", vim.log.levels.ERROR)
        return false
    end

    node = utils.find_nearest_parent_ts_node(
        node,
        { "arrow_function", "if_statement" }
    )
    if node == nil then
        return false
    end

    local query = vim.treesitter.query.parse(
        ft,
        [[
        (arrow_function
            body: (_) @body)
        (if_statement
        consequence: (_) @body
        )
        ]]
    )

    for _, n in query:iter_captures(node, bufnr, 0, -1) do
        -- if the node is not already a statement
        if n:type() ~= "statement_block" then
            -- add brackets around the body of the arrow function
            utils.replace_ts_node_text(bufnr, n, function(txt)
                return node:type() == "arrow_function"
                        and "{ return " .. txt[1] .. "; }"
                    or "{ " .. txt[1] .. " }"
            end)
            return true
        end
    end
    return false
end

--- Extracts the current node from a statement block and applies it to the parent node
--- useful for removing statement blocks from arrow functions and if statements to create a single statement
---
--- Used for arrow functions and if statements
--- @param bufnr integer
--- @param node TSNode|nil
--- @return boolean True the action updated the buffer, false otherwise
M.statement_block_surround_undo = function(bufnr, node)
    node = M._get_current_node(node)

    local ft = vim.bo[bufnr].filetype
    if not utils.check_filetype(ft) then
        error("shrub: filetype not supported", vim.log.levels.ERROR)
        return false
    end

    node = utils.find_nearest_parent_ts_node(
        node,
        { "arrow_function", "if_statement" }
    )
    if node == nil then
        return false
    end

    local query = vim.treesitter.query.parse(
        ft,
        [[
        (arrow_function
            body: (statement_block (return_statement (_) @return_val) ) @body
            )
        (if_statement
            consequence: (statement_block (return_statement (_) @return_val)) @body
            )
        ]]
    )

    -- get the statement block and the return statement
    ---@type TSNode|nil
    local stament_block = nil
    ---@type TSNode|nil
    local return_val = nil
    for _, n in query:iter_captures(node, bufnr, 0, -1) do
        if stament_block ~= nil and return_val ~= nil then
            break
        end
        if n:type() == "statement_block" then
            stament_block = n
        else
            return_val = n
        end
    end

    if stament_block == nil or return_val == nil then
        return false
    end

    utils.replace_ts_node_text(bufnr, stament_block, function()
        -- get range from the return statement
        local start_row, start_col, end_row, end_col = return_val:range()
        local new_text = vim.api.nvim_buf_get_text(
            bufnr,
            start_row,
            start_col,
            end_row,
            end_col,
            {}
        )
        return node:type() == "arrow_function" and new_text[1]
            or "return " .. new_text[1] .. ";"
    end)

    return true
end

return M
