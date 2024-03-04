local M = {}

M.format = function(opts)
    return require("conform").format({
        bufnr = opts.bufnr,
    })
end

return M
