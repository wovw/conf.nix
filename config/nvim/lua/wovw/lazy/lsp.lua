return { {
	"davidosomething/format-ts-errors.nvim",
	config = function()
		require("format-ts-errors").setup({
			add_markdown = true, -- wrap output with markdown ```ts ``` markers
			start_indent_level = 0, -- initial indent
		})
	end,
}, {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "KingMichaelPark/mason.nvim", opts = { pip = { use_uv = true } } },
		"KingMichaelPark/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
		"davidosomething/format-ts-errors.nvim",
	},

	config = function()
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		local nvim_lsp = require("lspconfig")
		-- Configure lua_ls directly with Nix binary
		nvim_lsp.lua_ls.setup({
			cmd = { "lua-language-server" },
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = { version = "Lua 5.1" },
					diagnostics = {
						globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
					},
				},
			},
		})

		require("fidget").setup({})
		require("mason").setup()
		require("mason-tool-installer").setup({
			ensure_installed = {
				"eslint_d",
				"prettierd",
				"gofumpt",
			},
		})
		require("mason-lspconfig").setup({
			ensure_installed = {
				"ruff",
				"rust_analyzer",
				"gopls",
				"nil_ls",
				"ts_ls",
				"eslint",
				"tailwindcss",
				"prismals",
			},
			automatic_installation = true,
			handlers = {
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,

				zls = function()
					local lspconfig = require("lspconfig")
					lspconfig.zls.setup({
						root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
						settings = {
							zls = {
								enable_inlay_hints = true,
								enable_snippets = true,
								warn_style = true,
							},
						},
					})
					vim.g.zig_fmt_parse_errors = 0
					vim.g.zig_fmt_autosave = 0
				end,
				["eslint"] = function()
					require("lspconfig").eslint.setup({
						capabilities = capabilities,
						flags = {
							debounce_text_changes = 1000, -- Delay before running
							allow_incremental_sync = false,
						},
						settings = {
							workingDirectory = { mode = "auto" },
							format = true,
							lint = true,
							run = "onType", -- or "onSave"
							-- Control which files ESLint runs on
							validate = "on",
							codeAction = {
								disableRuleComment = {
									enable = true,
									location = "separateLine",
								},
								showDocumentation = {
									enable = true,
								},
							},
						},
					})
				end,
				["nil_ls"] = function()
					require("lspconfig").nil_ls.setup({
						settings = {
							["nil"] = {
								formatting = {
									command = { "nixfmt" },
								},
							},
						},
					})
				end,
				["ts_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.ts_ls.setup({
						handlers = {
							["textDocument/publishDiagnostics"] = function(
								_,
								result,
								ctx,
								config
							)
								if result.diagnostics == nil then
									return
								end

								-- ignore some tsserver diagnostics
								local idx = 1
								while idx <= #result.diagnostics do
									local entry = result.diagnostics[idx]

									local formatter = require('format-ts-errors')[entry.code]
									entry.message = formatter and formatter(entry.message) or entry.message

									-- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
									if entry.code == 80001 then
										-- { message = "File is a CommonJS module; it may be converted to an ES module.", }
										table.remove(result.diagnostics, idx)
									else
										idx = idx + 1
									end
								end

								vim.lsp.diagnostic.on_publish_diagnostics(
									_,
									result,
									ctx,
									config
								)
							end,
						},
					})
				end,
			},
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
			}, {
				{ name = "buffer" },
			}),
		})

		vim.diagnostic.config({
			-- update_in_insert = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})

		vim.keymap.set("n", "gd", vim.lsp.buf.definition)
		vim.keymap.set("n", "gI", vim.lsp.buf.implementation) -- Useful when language has ways of declaring types without an actual implementation.
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
		vim.keymap.set("n", "K", vim.lsp.buf.hover)
		vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action)
		vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol)
		vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references)
		vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename)

		vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_next)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_prev)
	end,
} }
