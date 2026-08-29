local PBM = require('pbm')
local pluginName = 'sindrets/diffview.nvim'

local function init()
	local utils = require('utils')
	vim.pack.add({ utils.gh(pluginName) })
end

PBM:register({
	name = pluginName,
	init = init,
	dependencies = nil,
	options = nil,
})
