local PBM = require('pbm')
local pluginName = 'MeanderingProgrammer/render-markdown.nvim'

local function init()
	local utils = require('utils')
	vim.pack.add({ utils.gh(pluginName) })
	require('render-markdown').setup({})
end

PBM:register({
	name = pluginName,
	init = init,
	dependencies = {
		'nvim-treesitter/nvim-treesitter',
		'nvim-mini/mini.nvim',
	},
})
