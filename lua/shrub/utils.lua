local config = require("shrub.config")
local M = {}

---@param filetype string
---@return boolean True if the filetype is supported
M.check_filetype = function(filetype)
    return vim.tbl_contains(config.filetypes, filetype)
end

return M
