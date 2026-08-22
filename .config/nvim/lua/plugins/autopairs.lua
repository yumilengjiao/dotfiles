local PBM = require('pbm')
function init()
	local utils = require('utils')
	-- autopairs
	-- https://github.com/windwp/nvim-autopairs
	vim.pack.add({ utils.gh('windwp/nvim-autopairs') })
	require('nvim-autopairs').setup({})
end

PBM.register({ 'windwp/nvim-autopairs', init, nil, nil })
