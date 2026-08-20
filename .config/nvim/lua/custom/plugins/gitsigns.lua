local utils = require('config.utils')

vim.pack.add({ utils.gh('lewis6991/gitsigns.nvim') })
require('gitsigns').setup({
	signs = {
		add = { text = '▎' },
		change = { text = '▎' },
		delete = { text = '▎' },
		topdelete = { text = '▎' },
		changedelete = { text = '▎' },
	},
})
