local PBM = require('pbm')
local pluginName = 'folke/flash.nvim'

function init()
	local utils = require('utils')
	vim.pack.add({ utils.gh(pluginName) })
	require('flash').setup({})

	-- 普通跳转（对应原来的 leap 的 s）
	vim.keymap.set({ 'n', 'x', 'o' }, 's', function()
		require('flash').jump()
	end, { desc = 'Flash' })

	-- Treesitter 节点跳转/选择（对应原来的 an treeselect）
	vim.keymap.set({ 'n', 'x', 'o' }, 'S', function()
		require('flash').treesitter()
	end, { desc = 'Flash Treesitter' })

	-- Operator-pending 模式下的远程操作（跳转+操作+跳回，最接近原来的 gs / leap-visit）
	vim.keymap.set('o', 'r', function()
		require('flash').remote()
	end, { desc = 'Remote Flash' })

	-- Treesitter 搜索
	vim.keymap.set({ 'o', 'x' }, 'R', function()
		require('flash').treesitter_search()
	end, { desc = 'Treesitter Search' })

	-- 命令行模式下切换 flash 搜索
	vim.keymap.set('c', '<c-s>', function()
		require('flash').toggle()
	end, { desc = 'Toggle Flash Search' })
end

PBM:register({
	name = pluginName,
	init = init,
	dependencies = {},
	options = {},
})
