local PBM = require('pbm')
local pluginName = 'danymat/neogen'

local function init()
	local utils = require('utils')
	vim.pack.add({ utils.gh(pluginName) })
	require('neogen').setup({ snippet_engine = 'luasnip' })
end

PBM:register({
	name = pluginName,
	init = init,
	dependencies = nil,
	options = nil,
})
