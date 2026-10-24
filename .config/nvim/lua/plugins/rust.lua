local PBM = require('pbm')
local pluginName = 'mrcjkb/rustaceanvim'

local function init()
	local utils = require('utils')
	local cargo_home = vim.env.CARGO_HOME or vim.fs.joinpath(vim.fn.expand('~'), '.cargo')

	---@type rustaceanvim.Opts
	vim.g.rustaceanvim = {
		server = {
			-- Use the rustup proxy, even when Mason prepends its bin directory to PATH.
			cmd = { vim.fs.joinpath(cargo_home, 'bin', 'rust-analyzer') },
			on_attach = function(_, bufnr)
				vim.keymap.set('n', '<F5>', function()
					local dap = require('dap')
					if dap.session() then
						dap.continue()
					else
						-- Cargo builds the selected target and supplies its executable path.
						vim.cmd.RustLsp('debuggables')
					end
				end, { buffer = bufnr, desc = 'Rust: Debug Cargo Target / Continue' })

				vim.keymap.set('n', '<leader>dr', function()
					vim.cmd.RustLsp({ 'debuggables', bang = true })
				end, { buffer = bufnr, desc = 'Rust: Rebuild and Debug Last Target' })
			end,
		},
		-- CodeLLDB installed by Mason is detected automatically.
		-- Build only the selected target when debugging, not all targets on LSP attach.
		dap = { autoload_configurations = false },
	}

	vim.pack.add({
		{ src = utils.gh(pluginName), version = vim.version.range('^9') },
	})
end

PBM:register({
	name = pluginName,
	init = init,
	dependencies = { 'lsp', 'mfussenegger/nvim-dap' },
	options = nil,
})
