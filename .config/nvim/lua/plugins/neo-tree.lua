-- neo-tree.lua
--
-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

local PBM = require('pbm')
local pluginName = 'nvim-neo-tree/neo-tree.nvim'

local function init()
	local utils = require('utils')
	vim.pack.add({
		utils.gh(pluginName),
		utils.gh('nvim-lua/plenary.nvim'),
		utils.gh('MunifTanjim/nui.nvim'),
	})

	vim.keymap.set('n', '<leader>e', '<Cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })

	require('neo-tree').setup({
		filesystem = {
			window = {
				mappings = {
					['<leader>e'] = 'close_window',
				},
			},
		},
	})
end

PBM:register({
	name = pluginName,
	init = init,
	dependencies = nil,
	options = nil,
})
