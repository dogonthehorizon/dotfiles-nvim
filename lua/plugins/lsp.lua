return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"williamboman/mason.nvim",
		},
		opts = function()
			---@class PluginLspOpts
			local ret = {
				-- options for vim.diagnostic.config()
				---@type vim.diagnostic.Opts
				diagnostics = {
					underline = true,
					update_in_insert = false,
					virtual_text = {
						spacing = 4,
						source = "if_many",
						-- This will set set the prefix to a function that returns the diagnostics icon based on the severity
						-- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
						prefix = "icons",
					},
					severity_sort = true,
				},
				-- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
				-- Be aware that you also will need to properly configure your LSP server to
				-- provide the inlay hints.
				inlay_hints = {
					enabled = true,
					exclude = {}, -- File types for which you don't want to enable inlay hints
				},
				capabilities = {
					workspace = {
						fileOperations = {
							didRename = true,
							willRename = true,
						},
					},
				},
			}
			return ret
		end,
		config = function()
			-- Setup LSP servers
			local lspconfig = require("lspconfig")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local mason_lspconfig = require("mason-lspconfig")

			local keymap = vim.keymap
			local k_opts = { noremap = true, silent = true }

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true }

					keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					keymap.set("n", "gy", "<cmd>Telescope lsp_definitions<CR>", opts)
					keymap.set("n", "K", vim.lsp.buf.hover, opts)
					keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					keymap.set("n", "gR", vim.lsp.buf.rename, k_opts)
					keymap.set("n", "<leader>ac", vim.lsp.buf.code_action, opts)
					keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
					keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
					keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
					keymap.set("n", "gD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
				end,
			})

			local capabilities = cmp_nvim_lsp.default_capabilities()

			local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			mason_lspconfig.setup_handlers({
				-- default handler for installed servers
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = capabilities,
					})
				end,
				["lua_ls"] = function()
					lspconfig["lua_ls"].setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								workspace = {
									checkThirdParty = false,
								},
								codeLens = {
									enable = true,
								},
								completion = {
									callSnippet = "Replace",
								},
								doc = {
									privateName = { "^_" },
								},
								hint = {
									enable = true,
									setType = false,
									paramType = true,
									paramName = "Disable",
									semicolon = "Disable",
									arrayIndex = "Disable",
								},
							},
						},
					})
				end,
				["pyright"] = function()
					lspconfig["pyright"].setup({
						capabilities = capabilities,
						settings = {
							python = {
								analysis = {
									diagnosticMode = "openFilesOnly",
									autoImportCompletions = true,
								},
							},
						},
					})
				end,
				["jsonls"] = function()
					lspconfig["jsonls"].setup({
						capabilities = capabilities,
						settings = {
							json = {
								schemas = require("schemastore").json.schemas(),
								validate = {
									enable = true,
								},
							},
						},
					})
				end,
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		keys = { { "<leader>cM", "<cmd>Mason<cr>", desc = "Mason" } },
		config = function()
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			local mason_tool_installer = require("mason-tool-installer")

			---@diagnostic disable-next-line: missing-fields
			mason.setup({
				ui = {
					border = "rounded",
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			mason_lspconfig.setup({
				ensure_installed = {
					"lua_ls",
					"pyright",
					"hls",
					"terraformls",
					"ts_ls",
					"tailwindcss",
					"html",
					"cssls",
					"harper_ls",
					"dockerls",
					"jsonls",
				},
				automatic_installation = false,
			})

			mason_tool_installer.setup({
				ensure_installed = {
					-- formatters
					"prettier",
					"stylua",
					"ruff",
					"eslint_d",
					-- "pg_format", -- not available in mason yet
					"hadolint",
					"shellcheck",

					-- DAP
					"chrome-debug-adapter",
				},
			})
		end,
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"onsails/lspkind.nvim",
		},
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			table.insert(opts.sources, {
				name = "lazydev",
				group_index = 0, -- Set group index to 0 to skip loading LuaLS completions
			})
		end,
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				completion = {
					completeopt = "menu,menuone,preview",
				},
				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.select_prev_item(),
					["<C-j>"] = cmp.mapping.select_next_item(),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "vim-dadbod-completion" },
				},
				---@diagnostic disable-next-line: missing-fields
				formatting = {
					format = require("lspkind").cmp_format({
						max_width = 50,
						ellipsis_char = "...",
					}),
				},
				experimental = {
					ghost_text = true,
					native_menu = false,
				},
			})

			-- Setup lspconfig capabilities
			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
			require("lspconfig")["lua_ls"].setup({
				capabilities = capabilities,
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")

			conform.setup({
				formatters_by_ft = {
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					css = { "prettier" },
					html = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					lua = { "stylua" },
					python = { "ruff_format", "ruff_organize_imports" },
					sql = { "pg_format" },
					fish = { "fish_indent" },
					terraform = { "terraform_fmt" },
					tf = { "terraform_fmt" },
				},
				format_on_save = {
					lsp_fallback = true,
					timeout_ms = 500,
				},
			})
		end,
	},
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				python = { "ruff" },
				fish = { "fish" },
				dockerfile = { "hadolint" },
				terraform = { "terraform_validate" },
				tf = { "terraform_validate" },
				bash = { "shellcheck" },
				sh = { "shellcheck" },
			}

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})

			vim.keymap.set("n", "<leader>l", function()
				lint.try_lint()
			end, { desc = "Trigger linting for current file" })
		end,
	},
}
