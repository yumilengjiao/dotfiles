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

--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
	callback = function(event)
		-- 一个工具函数用来映射key
		local map = function(keys, func, desc, mode)
			mode = mode or 'n'
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
		end

		map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
		map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
		map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

		-- 光标停留高亮
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client:supports_method('textDocument/documentHighlight', event.buf) then
			local highlight_augroup =
				vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
			vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd('LspDetach', {
				group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({
						group = 'kickstart-lsp-highlight',
						buffer = event2.buf,
					})
				end,
			})
		end

		-- The following code creates a keymap to toggle inlay hints in your
		-- code, if the language server you are using supports them
		--
		-- This may be unwanted, since they displace some of your code
		if client and client:supports_method('textDocument/inlayHint', event.buf) then
			map('<leader>th', function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, '[T]oggle Inlay [H]ints')
		end
	end,
})
