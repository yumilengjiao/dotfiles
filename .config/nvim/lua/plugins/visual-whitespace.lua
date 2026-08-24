local PBM = require('pbm')
local pluginName = 'mcauley-penney/visual-whitespace.nvim'
local function init()
	local utils = require('utils')
	vim.pack.add({ utils.gh(pluginName) }, { load = false })
	vim.api.nvim_create_autocmd('ModeChanged', {
		pattern = '*:[vV\22]',
		once = true,
		callback = function()
			vim.cmd.packadd('visual-whitespace.nvim')
			require('visual-whitespace').setup({
				-- your opts here ...
			})
		end,
	})
end

PBM:register({
	name = pluginName,
	init = init,
	dependencies = nil,
	options = nil,
})
