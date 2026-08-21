local utils = require("custom.utils.lua")

vim.pack.add(utils.gh("guess-indent.nvim"))
require("guess-indent").setup({})
