local utils = require("shrub.utils")

---@class ShrubActionConfig
local M = {
    root_node_type = { "lexical_declaration" },
    query = [[
        (lexical_declaration
            (variable_declarator
                name: (_) @name
                value: (
                    arrow_function
                    parameters: (_) @params
                    body: (_) @body
                )
            )
        )@declaration
        ]],
    handle_captures = function(captures, bufnr)
        -- TODO: write multiple statement blocks or add formatting
        utils.replace_ts_node_text(bufnr, captures.declaration, function()
            return string.format(
                "function %s%s %s",
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
