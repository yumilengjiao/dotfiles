local PBM = require('pbm')
local pluginName = 'kdheepak/lazygit.nvim'

local function init()
	local utils = require('utils')
	vim.pack.add({ utils.gh(pluginName) })
	require('telescope').load_extension('lazygit')
	vim.keymap.set('n', '<leader>lg', '<cmd>LazyGit<cr>', { desc = '[L]azy git' })
end

PBM:register({
	name = pluginName,
	init = init,
	dependencies = {
		'telescope',
	},
	options = nil,
})
