local M = {}

M.filetypes = { "javascript", "typescript" }

M.keys = {
    {
        "n",
        "<leader>jer",
        '<cmd>lua require"shrub".statement_block_surround()<cr>',
        { noremap = true, silent = true },
    },
    {
        "n",
        "<leader>jir",
        '<cmd>lua require"shrub".statement_block_surround_undo()<cr>',
        { noremap = true, silent = true },
    },
}

return M
