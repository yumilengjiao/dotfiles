local PBM = require('pbm')
local pluginName = 'rafamadriz/friendly-snippets'

function init()
local utils = require("utils")
-- `friendly-snippets` contains a variety of premade snippets.
--    See the README about individual language/framework/plugin snippets:
--    https://github.com/rafamadriz/friendly-snippets
--
vim.pack.add({ utils.gh(pluginName) })
require("luasnip.loaders.from_vscode").lazy_load()
end

PBM:register({
	name = pluginName,
	init = init,
	dependencies = {"L3MON4D3/LuaSnip"},
	options = nil
})
