local utils = require("shrub.utils")
local M = {}

--- Surrounds the current node with a statement block
--- Used for arrow functions and if statements
--- @param bufnr integer
--- @param node TSNode|nil
--- @return boolean True the action updated the buffer, false otherwise
M.statement_block_surround = function(bufnr, node)
    if node == nil then
        node = vim.treesitter.get_node()
    end

    local ft = vim.bo[bufnr].filetype
    if not utils.check_filetype(ft) then
        error("shrub: filetype not supported", vim.log.levels.ERROR)
        return false
    end

    local node_type = nil
    -- get the nearest arrow function
    while node ~= nil do
        if node:type() == "arrow_function" then
            node_type = "arrow_function"
            break
        end
        if node:type() == "if_statement" then
            node_type = "if_statement"
            break
        end
        node = node:parent()
    end

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
            local start_row, start_col, end_row, end_col = n:range()

            local txt = vim.api.nvim_buf_get_text(
                bufnr,
                start_row,
                start_col,
                end_row,
                end_col,
                {}
            )

            vim.api.nvim_buf_set_text(
                bufnr,
                start_row,
                start_col,
                end_row,
                end_col,
                {
                    node_type == "arrow_function"
                            and "{ return " .. txt[1] .. "; }"
                        or "{ " .. txt[1] .. " }",
                }
            )
            return true
        end
    end
    return false
end

return M
