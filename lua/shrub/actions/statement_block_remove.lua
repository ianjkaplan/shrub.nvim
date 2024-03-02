local utils = require("shrub.utils")

---@class ShrubActionConfig
local M = {
    root_node_type = { "arrow_function", "if_statement" },
    query = [[
        (arrow_function
            body: (statement_block (return_statement (_) @return_val) ) @arrow_body
            )
        (if_statement
            consequence: (statement_block (return_statement (_) @return_val)) @condition_body
            )
        ]],
    handle_captures = function(captures, bufnr)
        local return_val = captures["return_val"]
        local arrow_body = captures["arrow_body"]
        local condition_body = captures["condition_body"]

        if arrow_body ~= nil then
            utils.replace_ts_node_text(bufnr, arrow_body, function()
                -- get range from the return statement
                local start_row, start_col, end_row, end_col =
                    return_val:range()
                local new_text = vim.api.nvim_buf_get_text(
                    bufnr,
                    start_row,
                    start_col,
                    end_row,
                    end_col,
                    {}
                )
                return new_text[1]
            end)
            return true
        end

        if condition_body ~= nil then
            utils.replace_ts_node_text(bufnr, condition_body, function()
                -- get range from the return statement
                local start_row, start_col, end_row, end_col =
                    return_val:range()
                local new_text = vim.api.nvim_buf_get_text(
                    bufnr,
                    start_row,
                    start_col,
                    end_row,
                    end_col,
                    {}
                )
                return "return " .. new_text[1] .. ";"
            end)
            return true
        end
    end,
}

return M
