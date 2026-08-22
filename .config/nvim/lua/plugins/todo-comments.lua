-- todo-comments.lua
--
-- Highlight todo, notes, etc in comments

local PBM = require('pbm')
local pluginName = 'folke/todo-comments.nvim'

local function init()
	local utils = require('utils')
	vim.pack.add({ utils.gh(pluginName) })
	require('todo-comments').setup({ signs = false })
end

PBM:register({
	name = pluginName,
	init = init,
	dependencies = nil,
	options = nil,
})
