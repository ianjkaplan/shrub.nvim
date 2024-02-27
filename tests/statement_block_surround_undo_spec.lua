---@diagnostic disable: deprecated
-- Run tests with source :PlenaryBustedFile %
-- Make sure to have the treesitter parser for javascript installed and in your runtimepath
describe("statement_block_surround_undo", function()
    local test_table = {
        {
            description = "should surround the arrow function with brackets",
            before = [[const myFn = () => { return "success"; };]],
            after = [[const myFn = () => "success";]],
            pos = { 0, 25 },
        },
        {
            description = "should surround the condition with brackets",
            before = [[if (true) { return "something"; }]],
            after = [[if (true) return "something";]],
            pos = { 0, 20 },
        },
    }

    for _, test in ipairs(test_table) do
        it(test.description, function()
            local test_buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_option(test_buf, "filetype", "javascript")
            -- write the js code to the buffer
            vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, { test.before })
            local node = vim.treesitter.get_node({
                lang = "javascript",
                bufnr = test_buf,
                pos = test.pos,
            })
            assert.is_true(
                require("shrub.actions").statement_block_surround_undo(
                    test_buf,
                    node
                )
            )
            assert.equals(
                test.after,
                vim.api.nvim_buf_get_lines(test_buf, 0, -1, false)[1]
            )
        end)
    end
end)
