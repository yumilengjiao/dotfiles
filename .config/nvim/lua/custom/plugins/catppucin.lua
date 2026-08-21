local utils = require("custom.utils")
vim.pack.add({ utils.gh("catppuccin/nvim") })
require("catppuccin").setup({
	flavour = "macchiato",
})
vim.cmd.colorscheme("catppuccin")
