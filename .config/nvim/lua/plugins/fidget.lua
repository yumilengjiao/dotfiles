-- fidget.lua
--
-- 这个插件是打开程序文件加载lsp时右下角会弹出lsp加载消息用的

local PBM = require('pbm')
local pluginName = 'j-hui/fidget.nvim'

local function init()
	local utils = require('utils')
	vim.pack.add({ utils.gh(pluginName) })
	require('fidget').setup({})
end

PBM:register({
	name = pluginName,
	init = init,
	dependencies = nil,
	options = nil,
})
