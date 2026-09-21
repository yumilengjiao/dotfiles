-- which-key.lua
--
-- Useful plugin to show you pending keybinds.

local PBM = require('pbm')
local pluginName = 'folke/which-key.nvim'

local function init()
	local utils = require('utils')
	vim.pack.add({ utils.gh(pluginName) })

	-- key groups

	require('which-key').setup({
		-- Delay between pressing a key and opening which-key (milliseconds)
		delay = 0,
		icons = { mappings = vim.g.have_nerd_font },
		-- Document existing key chains
		spec = {
			{ '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
			{ '<leader>t', group = '[T]oggle' },
			{ '<leader>d', group = '[D]ebug' },
			{ '<leader>l', group = '[L]azy' },
			{ '<leader>c', group = '[C]ode' },
			{ 'gr', group = 'LSP Actions', mode = { 'n' } },
		},
	})
end

PBM:register({
	name = pluginName,
	init = init,
	dependencies = nil,
	options = nil,
})
