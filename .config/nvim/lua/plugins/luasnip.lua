local PBM = require('pbm')
local pluginName = 'L3MON4D3/LuaSnip'
function init()
	local utils = require('utils')
	-- [[ Snippet Engine ]]

	vim.pack.add({ { src = utils.gh(pluginName), version = vim.version.range('2.*') } })
	require('luasnip').setup({})
end

PBM:register({
	name = pluginName,
	init = init,
	dependencies = nil,
	options = nil,
})
