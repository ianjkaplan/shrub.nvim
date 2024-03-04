local mock = require("luassert.mock")
---@diagnostic disable: deprecated
-- Run tests with source :PlenaryBustedFile %
-- Make sure to have the treesitter parser for javascript installed and in your runtimepath
describe("Actions:", function()
    local conform_mock = mock(require("shrub.format"), true)
    conform_mock.format.returns(true)

    local test_table = {
        {
            action = "statement_block_surround",
            description = "should surround the arrow function with brackets",
            before = [[const myFn = () => "success";]],
            after = [[const myFn = () => { return "success"; };]],
            pos = { 0, 25 },
        },
        {
            action = "statement_block_surround",
            description = "should surround the condition with brackets",
            before = [[if (true) return "something";]],
            after = [[if (true) { return "something"; }]],
            pos = { 0, 20 },
        },
        {
            action = "statement_block_remove",
            description = "should surround the arrow function with brackets",
            before = [[const myFn = () => { return "success"; };]],
            after = [[const myFn = () => "success";]],
            pos = { 0, 25 },
        },
        {
            action = "statement_block_remove",
            description = "should surround the condition with brackets",
            before = [[if (true) { return "something"; }]],
            after = [[if (true) return "something";]],
            pos = { 0, 20 },
        },
        {
            action = "fun_declaration_to_arrow",
            description = "should convert a function declaration to an arrow function",
            before = [[function myFn() { return "success"; }]],
            after = [[const myFn = () => { return "success"; }]],
            pos = { 0, 20 },
        },
        {
            action = "arrow_fun_to_declaration",
            description = "should convert an arrow function to a function declaration",
            before = [[const myFn = () => { return "success"; }]],
            after = [[function myFn() { return "success"; }]],
            pos = { 0, 25 },
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
                require("shrub.actions").run(test.action, test_buf, node)
            )
            assert.equals(
                test.after,
                vim.api.nvim_buf_get_lines(test_buf, 0, -1, false)[1]
            )
        end)
    end
end)
