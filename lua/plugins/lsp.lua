return {
	{
		"mason-org/mason.nvim",
		keys = { { "<leader>cM", "<cmd>Mason<cr>", desc = "Mason" } },
		---@diagnostic disable-next-line: missing-fields
		opts = {
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				"lua_ls",
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
			automatic_enable = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- Global capabilities for all LSP servers (cmp-nvim-lsp + file operations)
			vim.lsp.config("*", {
				capabilities = vim.tbl_deep_extend(
					"force",
					require("cmp_nvim_lsp").default_capabilities(),
					{
						workspace = {
							fileOperations = {
								didRename = true,
								willRename = true,
							},
						},
					}
				),
			})

			-- Enable ty (installed manually via uv, not Mason)
			vim.lsp.enable("ty")

			-- Diagnostics configuration
			vim.diagnostic.config({
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = function(diagnostic)
						local icons = {
							[vim.diagnostic.severity.ERROR] = "●",
							[vim.diagnostic.severity.WARN] = "▲",
							[vim.diagnostic.severity.HINT] = "⚑",
							[vim.diagnostic.severity.INFO] = "»",
						}
						return icons[diagnostic.severity] or "●"
					end,
				},
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "●",
						[vim.diagnostic.severity.WARN] = "▲",
						[vim.diagnostic.severity.HINT] = "⚑",
						[vim.diagnostic.severity.INFO] = "»",
					},
				},
			})

			-- Inlay hints
			vim.lsp.inlay_hint.enable(true)

			-- Buffer-local keymaps on LSP attach
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local buf_opts = { buffer = ev.buf, silent = true }

					vim.keymap.set("n", "gd", vim.lsp.buf.definition, buf_opts)
					vim.keymap.set("n", "gy", function()
						Snacks.picker.lsp_definitions()
					end, buf_opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, buf_opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, buf_opts)
					vim.keymap.set("n", "gR", vim.lsp.buf.rename, buf_opts)
					vim.keymap.set("n", "<leader>ac", vim.lsp.buf.code_action, buf_opts)
					vim.keymap.set("n", "gr", function()
						Snacks.picker.lsp_references()
					end, buf_opts)
					vim.keymap.set("n", "[d", function()
						vim.diagnostic.jump({ count = -1, float = true })
					end, buf_opts)
					vim.keymap.set("n", "]d", function()
						vim.diagnostic.jump({ count = 1, float = true })
					end, buf_opts)
					vim.keymap.set("n", "gD", function()
						Snacks.picker.diagnostics_buffer()
					end, buf_opts)
				end,
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				-- formatters
				"prettier",
				"stylua",
				"ruff",
				"luacheck",
				"eslint_d",
				-- "pg_format", -- not available in mason yet
				"hadolint",
				"shellcheck",

				-- DAP
				"js-debug-adapter",
			},
		},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				"snacks.nvim",
				"lazy.nvim",
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
			require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
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
				lua = { "luacheck" },
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
