local PBM = require('pbm')
local pluginName = 'akinsho/toggleterm.nvim'

local function init()
	local utils = require('utils')
	vim.pack.add({ utils.gh(pluginName) })

	-- 不设置 hidden 的话，终端关闭后内容会被丢弃
	vim.o.hidden = true

	require('toggleterm').setup({
		open_mapping = [[<C-/>]],
		direction = 'float', -- 浮动小终端，你也可以换成 'horizontal' / 'vertical' / 'tab'
		float_opts = {
			border = 'curved',
		},
		start_in_insert = true, -- 打开终端后自动进入插入模式，可以直接开始打字
		shade_terminals = true, -- 终端背景自动变暗一点，和普通buffer区分开
	})
end

PBM:register({
	name = pluginName,
	init = init,
	dependencies = {},
	options = {},
})
