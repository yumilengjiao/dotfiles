local PBM = require('pbm')
local pluginName = 'catppuccin/nvim'

local function init()
	local utils = require('utils')
	vim.pack.add({ utils.gh(pluginName) })
	require('catppuccin').setup({
		flavour = 'macchiato',
	})
	vim.cmd.colorscheme('catppuccin')
end

PBM:register({
	name = pluginName,
	init = init,
	dependencies = nil,
	options = nil,
})
