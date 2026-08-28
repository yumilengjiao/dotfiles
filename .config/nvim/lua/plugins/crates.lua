local PBM = require('pbm')
local pluginName = 'saecki/crates.nvim'

local function init()
	local utils = require('utils')
	vim.pack.add({ utils.gh(pluginName) })
	require('crates').setup({
		lsp = {
			enabled = true,
			actions = true,
			completion = true,
			hover = true,
		},
	})
end

PBM:register({
	name = pluginName,
	init = init,
	dependencies = nil,
	options = nil,
})
