local M = {}

-- local function get_filetype()
--     local ft = vim.bo.filetype
--     if ft ~= "javascript" and ft ~= "typescript" then
--         error("Shrubs is only supported for javascript and typescript files")
--     end
-- end

-- (arrow_function
--     body: (_) @body)
function Q()
    -- local ft = get_filetype()
    local bufnr = vim.api.nvim_get_current_buf()
    local tree = vim.treesitter.get_parser(bufnr, "javascript")
    local root = tree:parse()[1]

    local query = vim.treesitter.parse_query(
        "javascript",
        [[
(arrow_function
    body: (_) @body)
]]
    )

    for _, captures in query:iter_captures(root, bufnr) do
        P(captures)
    end
end

return M
