local utils = require("shrub.utils")

---@class ShrubActionConfig
local M = {
    query = [[
        (function_declaration
            name: (_) @name
            parameters: (_) @params
            body: (_) @body
            )
        ]],
    root_node_type = { "function_declaration" },
    handle_captures = function(captures, bufnr) end,
}

return M
