---function to have less repetition in the following sections.
---@param repo string
---@return string
local function gh(repo)
	return 'https://github.com/' .. repo
end

do
	-- Enable the following language servers
	--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
	--  See `:help lsp-config` for information about keys and how to configure
	---@type table<string, vim.lsp.Config>
	local servers = {
		-- clangd = {},
		-- gopls = {},
		-- pyright = {},
		-- rust_analyzer = {},
		--
		-- Some languages (like typescript) have entire language plugins that can be useful:
		--    https://github.com/pmizio/typescript-tools.nvim
		--
		-- But for many setups, the LSP (`ts_ls`) will work just fine
		-- ts_ls = {},

		stylua = {}, -- Used to format Lua code

		-- Special Lua Config, as recommended by neovim help docs
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
						-- NOTE: this is a lot slower and will cause issues when working on your own configuration.
						--  See https://github.com/neovim/nvim-lspconfig/issues/3189
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
		gh('neovim/nvim-lspconfig'),
		gh('mason-org/mason.nvim'),
		gh('mason-org/mason-lspconfig.nvim'),
		gh('WhoIsSethDaniel/mason-tool-installer.nvim'),
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
	})

	require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

	for name, server in pairs(servers) do
		vim.lsp.config(name, server)
		-- vim.lsp.enable(name) 这个不需要了，因为上面有automatic_enable
	end
end

-- ============================================================
-- SECTION 7: FORMATTING
-- conform.nvim setup and keymap
-- ============================================================
do
	-- [[ Formatting ]]
	vim.pack.add({ gh('stevearc/conform.nvim') })
	require('conform').setup({
		notify_on_error = false,
		format_on_save = function(bufnr)
			-- You can specify filetypes to autoformat on save here:
			local enabled_filetypes = {
				-- lua = true,
				-- python = true,
			}
			if enabled_filetypes[vim.bo[bufnr].filetype] then
				return { timeout_ms = 500 }
			else
				return nil
			end
		end,
		default_format_opts = {
			lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
		},
		-- You can also specify external formatters in here.
		formatters_by_ft = {
			-- rust = { 'rustfmt' },
			-- Conform can also run multiple formatters sequentially
			-- python = { "isort", "black" },
			--
			-- You can use 'stop_after_first' to run the first available formatter from the list
			-- javascript = { "prettierd", "prettier", stop_after_first = true },
		},
	})

	vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
		require('conform').format({ async = true })
	end, { desc = '[F]ormat buffer' })
end

-- ============================================================
-- SECTION 8: AUTOCOMPLETE & SNIPPETS
-- blink.cmp and luasnip setup
-- ============================================================
do
	-- [[ Snippet Engine ]]

	-- NOTE: You can also specify plugin using a version range for its git tag.
	--  See `:help vim.version.range()` for more info
	vim.pack.add({ { src = gh('L3MON4D3/LuaSnip'), version = vim.version.range('2.*') } })
	require('luasnip').setup({})

	-- `friendly-snippets` contains a variety of premade snippets.
	--    See the README about individual language/framework/plugin snippets:
	--    https://github.com/rafamadriz/friendly-snippets
	--
	-- vim.pack.add { gh 'rafamadriz/friendly-snippets' }
	-- require('luasnip.loaders.from_vscode').lazy_load()

	-- [[ Autocomplete Engine ]]
	vim.pack.add({ { src = gh('saghen/blink.cmp'), version = vim.version.range('1.*') } })
	require('blink.cmp').setup({
		keymap = {
			-- 'default' (recommended) for mappings similar to built-in completions
			--   <c-y> to accept ([y]es) the completion.
			--    This will auto-import if your LSP supports it.
			--    This will expand snippets if the LSP sent a snippet.
			-- 'super-tab' for tab to accept
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- For an understanding of why the 'default' preset is recommended,
			-- you will need to read `:help ins-completion`
			--
			-- No, but seriously. Please read `:help ins-completion`, it is really good!
			--
			-- All presets have the following mappings:
			-- <tab>/<s-tab>: move to right/left of your snippet expansion
			-- <c-space>: Open menu or open docs if already open
			-- <c-n>/<c-p> or <up>/<down>: Select next/previous item
			-- <c-e>: Hide menu
			-- <c-k>: Toggle signature help
			--
			-- See `:help blink-cmp-config-keymap` for defining your own keymap
			preset = 'default',

			-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
			--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
		},

		appearance = {
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = 'mono',
		},

		completion = {
			-- By default, you may press `<c-space>` to show the documentation.
			-- Optionally, set `auto_show = true` to show the documentation after a delay.
			documentation = { auto_show = false, auto_show_delay_ms = 500 },
		},

		sources = {
			default = { 'lsp', 'path', 'snippets' },
		},

		snippets = { preset = 'luasnip' },

		-- Blink.cmp includes an optional, recommended rust fuzzy matcher,
		-- which automatically downloads a prebuilt binary when enabled.
		--
		-- By default, we use the Lua implementation instead, but you may enable
		-- the rust implementation via `'prefer_rust_with_warning'`
		--
		-- See `:help blink-cmp-config-fuzzy` for more information
		fuzzy = { implementation = 'lua' },

		-- Shows a signature help window while you type arguments for a function
		signature = { enabled = true },
	})
end

-- ============================================================
-- SECTION 9: TREESITTER
-- Parser installation, syntax highlighting, folds, indentation
-- ============================================================
do
	-- [[ Configure Treesitter ]]
	--  Used to highlight, edit, and navigate code
	--
	--  See `:help nvim-treesitter-intro`

	-- NOTE: You can also specify a branch or a specific commit
	vim.pack.add({ { src = gh('nvim-treesitter/nvim-treesitter'), version = 'main' } })

	-- Ensure basic parsers are installed
	local parsers = {
		'bash',
		'c',
		'diff',
		'html',
		'lua',
		'luadoc',
		'markdown',
		'markdown_inline',
		'query',
		'vim',
		'vimdoc',
	}
	require('nvim-treesitter').install(parsers)

	---@param buf integer
	---@param language string
	local function treesitter_try_attach(buf, language)
		-- Check if a parser exists and load it
		if not vim.treesitter.language.add(language) then
			return
		end
		-- Enable syntax highlighting and other treesitter features
		vim.treesitter.start(buf, language)

		-- Enable treesitter based folds
		-- For more info on folds see `:help folds`
		-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
		-- vim.wo.foldmethod = 'expr'

		-- Check if treesitter indentation is available for this language, and if so enable it
		-- in case there is no indent query, the indentexpr will fallback to the vim's built in one
		local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

		-- Enable treesitter based indentation
		if has_indent_query then
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end

	local available_parsers = require('nvim-treesitter').get_available()
	vim.api.nvim_create_autocmd('FileType', {
		callback = function(args)
			local buf, filetype = args.buf, args.match

			local language = vim.treesitter.language.get_lang(filetype)
			if not language then
				return
			end

			local installed_parsers = require('nvim-treesitter').get_installed('parsers')

			if vim.tbl_contains(installed_parsers, language) then
				-- Enable the parser if it is already installed
				treesitter_try_attach(buf, language)
			elseif vim.tbl_contains(available_parsers, language) then
				-- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
				require('nvim-treesitter').install(language):await(function()
					treesitter_try_attach(buf, language)
				end)
			else
				-- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
				treesitter_try_attach(buf, language)
			end
		end,
	})
end

-- ============================================================
-- SECTION 10: OPTIONAL EXAMPLES / NEXT STEPS
-- kickstart.plugins.* examples
-- ============================================================
do
	-- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
	-- init.lua. If you want these files, they are in the repository, so you can just download them and
	-- place them in the correct locations.

	-- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
	--
	--  Here are some example plugins that I've included in the Kickstart repository.
	--  Uncomment any of the lines below to enable them (you will need to restart nvim).
	--
	-- require 'kickstart.plugins.debug'
	-- require 'kickstart.plugins.indent_line'
	-- require 'kickstart.plugins.lint'
	-- require 'kickstart.plugins.autopairs'
	-- require 'kickstart.plugins.neo-tree'
	-- require 'kickstart.plugins.gitsigns' -- adds gitsigns recommended keymaps

	-- NOTE: You can add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
	--
	--  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
	-- require 'custom.plugins'
end

-- The line beneath this is called `modeline`. See `:help modeline`
