local M = {}

M.filetypes = { "javascript", "typescript" }

M.keys = {
    {
        "n",
        "<leader>jer",
        '<cmd>lua require"shrub".statement_block_surround()<cr>',
        {
            noremap = true,
            silent = true,
            desc = "intelligent surround with statement block",
        },
    },
    {
        "n",
        "<leader>jir",
        '<cmd>lua require"shrub".statement_block_remove()<cr>',
        {
            noremap = true,
            silent = true,
            desc = "intelligent remove surrounding statement block",
        },
    },
    {
        "n",
        "<leader>jfa",
        '<cmd>lua require"shrub".fun_declaration_to_arrow()<cr>',
        {
            noremap = true,
            silent = true,
            desc = "convert a function declaration to an arrow function",
        },
    },
    {
        "n",
        "<leader>jaf",
        '<cmd>lua require"shrub".arrow_fun_to_declaration()<cr>',
        {
            noremap = true,
            silent = true,
            desc = "convert an arrow function to a function declaration",
        },
    },
}

return M
