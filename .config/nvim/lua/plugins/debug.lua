-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

local PBM = require('pbm')
local pluginName = 'mfussenegger/nvim-dap'

local function init()
	local utils = require('utils')

	vim.pack.add({
		utils.gh(pluginName),
		utils.gh('rcarriga/nvim-dap-ui'),
		utils.gh('nvim-neotest/nvim-nio'),
		utils.gh('mason-org/mason.nvim'),
		utils.gh('jay-babu/mason-nvim-dap.nvim'),
		utils.gh('leoluz/nvim-dap-go'),
	})

	-- Basic debugging keymaps, feel free to change to your liking!
	vim.keymap.set('n', '<F5>', function()
		require('dap').continue()
	end, { desc = 'Debug: Start/Continue' })
	vim.keymap.set('n', '<F1>', function()
		require('dap').step_into()
	end, { desc = 'Debug: Step Into' })
	vim.keymap.set('n', '<F2>', function()
		require('dap').step_over()
	end, { desc = 'Debug: Step Over' })
	vim.keymap.set('n', '<F3>', function()
		require('dap').step_out()
	end, { desc = 'Debug: Step Out' })
	vim.keymap.set('n', '<leader>dt', function()
		require('dap').terminate()
	end, { desc = 'Debug: Terminate' })
	vim.keymap.set('n', '<leader>db', function()
		require('dap').toggle_breakpoint()
	end, { desc = 'Debug: Toggle Breakpoint' })
	vim.keymap.set('n', '<leader>dB', function()
		require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
	end, { desc = 'Debug: Set Breakpoint' })
	-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
	vim.keymap.set('n', '<F7>', function()
		require('dapui').toggle()
	end, { desc = 'Debug: See last session result.' })

	local dap = require('dap')
	local dapui = require('dapui')

	require('mason-nvim-dap').setup({
		-- Makes a best effort to setup the various debuggers with
		-- reasonable debug configurations
		automatic_installation = true,
		-- You can provide additional configuration to the handlers,
		-- see mason-nvim-dap README for more information
		handlers = {},
		-- You'll need to check that you have the required things installed
		-- online, please don't ask me how to install them :)
		ensure_installed = {
			-- Update this to ensure that you have the debuggers for the langs you want
			'delve',
			'codelldb',
		},
	})

	-- Dap UI setup
	-- For more information, see |:help nvim-dap-ui|
	---@diagnostic disable-next-line: missing-fields
	dapui.setup({
		-- Set icons to characters that are more likely to work in every terminal.
		--    Feel free to remove or use ones that you like more! :)
		--    Don't feel like these are good choices.
		icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
		---@diagnostic disable-next-line: missing-fields
		controls = {
			icons = {
				pause = '⏸',
				play = '▶',
				step_into = '⏎',
				step_over = '⏭',
				step_out = '⏮',
				step_back = 'b',
				run_last = '▶▶',
				terminate = '⏹',
				disconnect = '⏏',
			},
		},
	})

	-- High-contrast breakpoint markers and the current execution line.
	local function set_debug_highlights()
		vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#ff0000', bold = true })
		vim.api.nvim_set_hl(0, 'DapBreakpointCondition', { fg = '#ff00ff', bold = true })
		vim.api.nvim_set_hl(0, 'DapBreakpointRejected', { fg = '#ff8800', bold = true })
		vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#00ffff', bold = true })
		vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#000000', bg = '#ffff00', bold = true })
		vim.api.nvim_set_hl(0, 'DapStoppedLine', { fg = '#000000', bg = '#ffff00', bold = true })
	end

	set_debug_highlights()
	vim.api.nvim_create_autocmd('ColorScheme', {
		group = vim.api.nvim_create_augroup('dotfiles-dap-highlights', { clear = true }),
		callback = set_debug_highlights,
	})

	local breakpoint_icons = {
		Breakpoint = '●',
		BreakpointCondition = '◆',
		BreakpointRejected = '⊘',
		LogPoint = '◆',
		Stopped = '▶',
	}
	for kind, icon in pairs(breakpoint_icons) do
		local name = 'Dap' .. kind
		vim.fn.sign_define(name, {
			text = icon,
			texthl = name,
			numhl = name,
			linehl = kind == 'Stopped' and 'DapStoppedLine' or '',
		})
	end

	dap.listeners.after.event_initialized['dapui_config'] = dapui.open
	dap.listeners.before.event_terminated['dapui_config'] = dapui.close
	dap.listeners.before.event_exited['dapui_config'] = dapui.close

	-- Install golang specific config
	require('dap-go').setup({
		delve = {
			-- On Windows delve must be run attached or it crashes.
			-- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
			detached = vim.fn.has('win32') == 0,
		},
	})
end

PBM:register({
	name = pluginName,
	init = init,
	dependencies = { 'lsp' }, -- Mason must add its bin directory before DAP adapters are resolved.
	options = nil,
})
