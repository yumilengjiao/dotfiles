local utils = require('utils')
-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add({
	utils.gh 'nvim-neo-tree/neo-tree.nvim',
	utils.gh 'nvim-lua/plenary.nvim',
	utils.gh 'MunifTanjim/nui.nvim',
})

vim.keymap.set('n', '\\', '<Cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })

require('neo-tree').setup({
	filesystem = {
		window = {
			mappings = {
				['\\'] = 'close_window',
			},
		},
	},
})
