local PBM = require('pbm')
local pluginName = 'windwp/nvim-autopairs'

local function init()
	local utils = require('utils')
	-- autopairs
	-- https://github.com/windwp/nvim-autopairs
	vim.pack.add({ utils.gh(pluginName) })
	require('nvim-autopairs').setup({})
end

PBM:register({
	name = 'windwp/nvim-autopairs',
	init = init,
	dependencies = nil,
	options = nil,
})
