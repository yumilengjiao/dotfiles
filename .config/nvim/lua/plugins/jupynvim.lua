local PBM = require('pbm')
local pluginName = 'sheng-tse/jupynvim'

local function init()
	local utils = require('utils')
	vim.pack.add({ { utils.gh(pluginName), version = vim.version.range('*') } })
	require('jupynvim').setup({})
end

PBM:register({
	name = pluginName,
	init = init,
	dependencies = nil,
	options = nil,
})
