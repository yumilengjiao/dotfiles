local utils = require('utils')
-- [[ Snippet Engine ]]

vim.pack.add({ { src = utils.gh('L3MON4D3/LuaSnip'), version = vim.version.range('2.*') } })
require('luasnip').setup({})
