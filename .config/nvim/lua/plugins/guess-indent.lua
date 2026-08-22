-- guess-indent.lua

local PBM = require('pbm')
local pluginName = 'nmac427/guess-indent.nvim'

local function init()
	local utils = require('utils')
	vim.pack.add({ utils.gh(pluginName) })
	require('guess-indent').setup({})
end

PBM:register({
	name = pluginName,
	init = init,
	dependencies = nil,
	options = nil,
})
