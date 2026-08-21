local utils = require("utils")
-- Add indentation guides even on blank lines

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help ibl`
vim.pack.add({ utils.gh("lukas-reineke/indent-blankline.nvim") })
require("ibl").setup({})
