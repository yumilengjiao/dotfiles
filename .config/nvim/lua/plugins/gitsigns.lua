-- gitsigns.lua

local PBM = require('pbm')
local pluginName = 'lewis6991/gitsigns.nvim'

local function init()
	local utils = require('utils')
	vim.pack.add({ utils.gh(pluginName) })

	-- 手动指定颜色,拉开 add/change/delete 之间的区分度
	vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = '#89d88b' }) -- 绿色系:新增
	vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = '#e0af68' }) -- 黄/橙色系:修改
	vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = '#f7768e' }) -- 红色系:删除

	require('gitsigns').setup({
		signs = {
			add = { text = '▌' },
			change = { text = '▌' },
			delete = { text = '▌' },
			topdelete = { text = '▌' },
			changedelete = { text = '▌' },
		},
	})
end

PBM:register({
	name = pluginName,
	init = init,
	dependencies = nil,
	options = nil,
})
