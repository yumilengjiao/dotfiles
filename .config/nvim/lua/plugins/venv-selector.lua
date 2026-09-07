local PBM = require('pbm')
local pluginName = 'linux-cultist/venv-selector.nvim'

local function init()
	local utils = require('utils')
	vim.pack.add({ utils.gh(pluginName) })
	require('venv-selector').setup({
		search = {},
		options = {},
	})
	vim.keymap.set('n', ',v', '<cmd>VenvSelect<cr>', { desc = 'Select Python venv' })
end

PBM:register({
	name = pluginName,
	init = init,
	dependencies = {
		'telescope',
	},
	options = nil,
})
