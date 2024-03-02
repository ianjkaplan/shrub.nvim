---@alias ShrubAction "statement_block_surround" | "statement_block_remove" | "fun_declaration_to_arrow" | "arrow_fun_to_declaration"

---@class ShrubActionConfig
---@field query string treesitter query string
---@field root_node_type string[] nearest node type that will be used as the root of the query
---@field handle_captures fun(captures:table<string,TSNode>, bufnr:integer): any execute an action on table of captured nodes based on the captures where the key is the capture name and the value is the TSNode
