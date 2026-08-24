local PBM = require('pbm')

local pluginName = 'karb94/neoscroll.nvim'
local function init()
	local utils = require('utils')
	vim.pack.add({ utils.gh(pluginName) })
	require('neoscroll').setup({
		mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>' },
		duration_multiplier = 0.6,
	})
end

PBM:register({
	name = pluginName,
	init = init,
	dependencies = nil,
	options = nil,
})
