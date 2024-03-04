local config = require("shrub.config")
local format = require("shrub.format").format
local M = {}

---@param filetype string
---@return boolean True if the filetype is supported
M.check_filetype = function(filetype)
    return vim.tbl_contains(config.filetypes, filetype)
end

--- @param node TSNode|nil the node to find the nearest parent node
--- @param types string[] The type of the parent node to find
M.find_nearest_parent_ts_node = function(node, types)
    while node ~= nil do
        if vim.tbl_contains(types, node:type()) then
            return node
        end
        node = node:parent()
    end
    return nil
end

M.get_ts_node_text = function(bufnr, node)
    local start_row, start_col, end_row, end_col = node:range()
    return vim.api.nvim_buf_get_text(
        bufnr,
        start_row,
        start_col,
        end_row,
        end_col,
        {}
    )
end

---@param bufnr integer
---@param node TSNode
---@param callback function accepts a string[] and returns a string to replace the node text with
M.replace_ts_node_text = function(bufnr, node, callback)
    -- add brackets around the body of the arrow function
    local start_row, start_col, end_row, end_col = node:range()

    local txt = vim.api.nvim_buf_get_text(
        bufnr,
        start_row,
        start_col,
        end_row,
        end_col,
        {}
    )

    local result = callback(txt)

    vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, {
        result,
    })

    return format({
        bufnr = bufnr,
    })
end

return M
