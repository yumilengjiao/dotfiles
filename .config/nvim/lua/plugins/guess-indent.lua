local utils = require("utils")

vim.pack.add({ utils.gh("guess-indent.nvim") })
require("guess-indent").setup({})
