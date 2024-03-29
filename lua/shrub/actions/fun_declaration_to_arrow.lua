local utils = require("shrub.utils")

---@class ShrubActionConfig
local M = {
    root_node_type = { "function_declaration" },
    query = [[
        (function_declaration
            name: (_) @name
            parameters: (_) @params
            body: (_) @body
            ) @func
        ]],
    handle_captures = function(captures, bufnr)
        utils.replace_ts_node_text(bufnr, captures.func, function()
            -- TODO: write multiple statement blocks or add formatting
            return string.format(
                "const %s = %s => %s",
                table.concat(utils.get_ts_node_text(bufnr, captures.name), " "),
                table.concat(
                    utils.get_ts_node_text(bufnr, captures.params),
                    " "
                ),
                table.concat(utils.get_ts_node_text(bufnr, captures.body), " ")
            )
        end)
    end,
}

return M
