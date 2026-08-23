-- lsp.lua

local PBM = require('pbm')
local pluginName = 'lsp'

local function init()
	local utils = require('utils')

	---@type table<string, vim.lsp.Config>
	local servers = {
		-- clangd = {},
		-- gopls = {},
		-- pyright = {},
		rust_analyzer = {},
		lua_ls = {
			on_init = function(client)
				client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)
				if client.workspace_folders then
					local path = client.workspace_folders[1].name
					if
						-- 这里就是在说，如果项目根目录不是我的nvim配置目录，而且项目下面没有.luarc.json和.luarc.jsonc()
						-- 才往下走使用我自己的lua语言服务器配置，否则用项目配置(类似tsconfig)
						path ~= vim.fn.stdpath('config')
						and (
							vim.uv.fs_stat(path .. '/.luarc.json')
							or vim.uv.fs_stat(path .. '/.luarc.jsonc')
						)
					then
						return
					end
				end
				local current_settings = client.config.settings --[[@as lspconfig.settings.lua_ls]]
				client.config.settings.Lua = vim.tbl_deep_extend('force', current_settings.Lua, {
					runtime = {
						version = 'LuaJIT',
						path = { 'lua/?.lua', 'lua/?/init.lua' },
					},
					workspace = {
						checkThirdParty = false,
						-- 这里就是第二个参数true会递归调用库目录下的所有lua文件，所以lsp加载很慢
						library = vim.api.nvim_get_runtime_file('', true),
					},
				})
			end,
			---@type lspconfig.settings.lua_ls
			settings = {
				Lua = {
					format = { enable = false }, -- Disable formatting (formatting is done by stylua)
				},
			},
		},
	}

	vim.pack.add({
		utils.gh('neovim/nvim-lspconfig'),
		utils.gh('mason-org/mason.nvim'),
		utils.gh('mason-org/mason-lspconfig.nvim'),
		utils.gh('WhoIsSethDaniel/mason-tool-installer.nvim'),
	})

	-- Automatically install LSPs and related tools to stdpath for Neovim
	require('mason').setup({})

	-- Translates between nvim-lspconfig server names and mason.nvim package names (e.g. lua_ls <-> lua-language-server)
	require('mason-lspconfig').setup({
		automatic_enable = true, -- Change this to true if you want to automatically enable servers that are installed manually (e.g. via :Mason / :MasonInstall)
	})

	-- Ensure the servers and tools above are installed
	--
	-- To check the current status of installed tools and/or manually install
	-- other tools, you can run
	--    :Mason
	--
	-- You can press `g?` for help in this menu.
	local ensure_installed = vim.tbl_keys(servers or {})
	vim.list_extend(ensure_installed, {
		-- You can add other tools here that you want Mason to install
		'stylua',
	})
	require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

	for name, server in pairs(servers) do
		vim.lsp.config(name, server)
		-- vim.lsp.enable(name) 这个不需要了，因为上面有automatic_enable
	end
end

PBM:register({
	name = pluginName,
	init = init,
	dependencies = nil,
	options = nil,
})
