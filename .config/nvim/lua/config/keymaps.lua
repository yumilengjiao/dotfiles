vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic Config & Keymaps
--  See `:help vim.diagnostic.Opts`
vim.diagnostic.config({
	update_in_insert = false,
	severity_sort = true,
	float = { border = 'rounded', source = 'if_many' },
	underline = { severity = { min = vim.diagnostic.severity.WARN } },

	-- Can switch between these as you prefer
	virtual_text = true, -- Text shows up at the end of the line
	virtual_lines = false, -- Text shows up underneath the line, with virtual lines

	-- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
	jump = {
		on_jump = function(_, bufnr)
			vim.diagnostic.open_float({
				bufnr = bufnr,
				scope = 'cursor',
				focus = false,
			})
		end,
	},
})

-- Diagnostics
vim.keymap.set('n', '<leader>cl', vim.diagnostic.setloclist, {
	desc = 'Diagnostic [L]ist',
})

vim.keymap.set('n', '<leader>cq', vim.diagnostic.setqflist, {
	desc = 'Diagnostic [Q]uickfix',
})

vim.keymap.set('n', '<leader>co', vim.diagnostic.open_float, {
	desc = 'Diagnostic [O]pen',
})

vim.keymap.set('n', '<leader>cn', function()
	vim.diagnostic.jump({ count = 1 })
end, {
	desc = 'Diagnostic [N]ext',
})

vim.keymap.set('n', '<leader>cp', function()
	vim.diagnostic.jump({ count = -1 })
end, {
	desc = 'Diagnostic [P]revious',
})

vim.keymap.set('n', '<leader>cf', function()
	vim.diagnostic.jump({ count = -1, wrap = false })
end, {
	desc = 'Diagnostic [F]irst',
})

vim.keymap.set('n', '<leader>cL', function()
	vim.diagnostic.jump({ count = 1, wrap = false })
end, {
	desc = 'Diagnostic [L]ast',
})

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<C-S-h>', '<C-w>H', { desc = 'Move window to the left' })
vim.keymap.set('n', '<C-S-l>', '<C-w>L', { desc = 'Move window to the right' })
vim.keymap.set('n', '<C-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
vim.keymap.set('n', '<C-S-k>', '<C-w>K', { desc = 'Move window to the upper' })
