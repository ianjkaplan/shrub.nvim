local utils = require("shrub.utils")

---@class ShrubActionConfig
local M = {
    root_node_type = { "arrow_function", "if_statement" },
    query = [[
        (arrow_function
            body: (_) @arrow_body)
        (if_statement
        consequence: (_) @condition_body
        ) 
        ]],
    handle_captures = function(captures, bufnr)
        if captures["condition_body"] ~= nil then
            utils.replace_ts_node_text(
                bufnr,
                captures["condition_body"],
                function(txt)
                    return "{ " .. txt[1] .. " }"
                end
            )
            return true
        end

        if captures["arrow_body"] ~= nil then
            utils.replace_ts_node_text(
                bufnr,
                captures["arrow_body"],
                function(txt)
                    return "{ return " .. txt[1] .. "; }"
                end
            )
            return true
        end
    end,
}

return M
