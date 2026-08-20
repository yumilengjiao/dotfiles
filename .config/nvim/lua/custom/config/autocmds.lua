local utils = require('custom.utils')
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- 这里维护了一份白名单，用于对特定需要编译的插进进行额外工作
vim.api.nvim_create_autocmd('PackChanged', {
	callback = function(ev)
		local name = ev.data.spec.name
		local kind = ev.data.kind
		if kind ~= 'install' and kind ~= 'update' then
			return
		end

		if name == 'telescope-fzf-native.nvim' and vim.fn.executable('make') == 1 then
			utils.run_build(name, { 'make' }, ev.data.path)
			return
		end

		if name == 'LuaSnip' then
			if vim.fn.has('win32') ~= 1 and vim.fn.executable('make') == 1 then
				utils.run_build(name, { 'make', 'install_jsregexp' }, ev.data.path)
			end
			return
		end

		if name == 'nvim-treesitter' then
			if not ev.data.active then
				vim.cmd.packadd('nvim-treesitter')
			end
			vim.cmd('TSUpdate')
			return
		end
	end,
})
