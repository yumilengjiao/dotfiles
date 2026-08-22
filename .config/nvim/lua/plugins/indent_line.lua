-- indent-blankline.lua
--
-- Add indentation guides even on blank lines
-- See `:help ibl`

local PBM = require('pbm')
local pluginName = 'lukas-reineke/indent-blankline.nvim'

local function init()
	local utils = require('utils')
	vim.pack.add({ utils.gh(pluginName) })
	require('ibl').setup({})
end

PBM:register({
	name = pluginName,
	init = init,
	dependencies = nil,
	options = nil,
})
