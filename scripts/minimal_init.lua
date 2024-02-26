-- add nvim-treesitter from lazy to runtimepath
vim.o.runtimepath = vim.o.runtimepath
    .. ","
    .. vim.fn.expand("~/.local/share/nvim/lazy/nvim-treesitter")
