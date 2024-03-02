local utils = require("shrub.utils")

---@class ShrubActionConfig
local M = {
    query = [[
            (variable_declarator
                name: (_) @name 
                value: (
                    arrow_function
                    parameters: (_) @params
                    body: (_) @body
                )
            )
        ]],
    root_node_type = { "variable_declarator" },
    handle_captures = function(captures, bufnr) end,
}

return M
