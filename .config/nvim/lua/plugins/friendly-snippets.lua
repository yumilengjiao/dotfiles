local utils = require("utils")
-- `friendly-snippets` contains a variety of premade snippets.
--    See the README about individual language/framework/plugin snippets:
--    https://github.com/rafamadriz/friendly-snippets
--
vim.pack.add({ utils.gh("rafamadriz/friendly-snippets") })
require("luasnip.loaders.from_vscode").lazy_load()
