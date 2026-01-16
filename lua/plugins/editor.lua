-- Shift key fixes
vim.cmd("command! -bang -nargs=* -complete=file E e<bang> <args>")
vim.cmd("command! -bang -nargs=* -complete=file W w<bang> <args>")
vim.cmd("command! -bang -nargs=* -complete=file Wq wq<bang> <args>")
vim.cmd("command! -bang -nargs=* -complete=file WQ wq<bang> <args>")
vim.cmd("command! -bang Wa wa<bang>")
vim.cmd("command! -bang WA wa<bang>")
vim.cmd("command! -bang Q   q<bang>")
vim.cmd("command! -bang QA qa<bang>")
vim.cmd("command! -bang Qa qa<bang>")
vim.cmd("command! -bang Tabn tabn<bang>")

return {
	-- Utilities
	"preservim/nerdcommenter",
	"godlygeek/tabular",
	"Townk/vim-autoclose",
	{
		"echasnovski/mini.surround",
		version = "*",
		opts = {},
	},
	"tpope/vim-vinegar",
	"tpope/vim-obsession",
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPre", "BufNewFile" },
		main = "ibl",
		opts = {
			indent = { char = "┊" },
		},
	},

	{
		"hiphish/rainbow-delimiters.nvim",
		lazy = false,
		init = function()
			require("rainbow-delimiters")
			require("rainbow-delimiters.setup").setup()
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })()
		end,
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = {
					"bash",
					"css",
					"dockerfile",
					"fish",
					"git_config",
					"git_rebase",
					"gitattributes",
					"gitcommit",
					"gitignore",
					"go",
					"gomod",
					"gosum",
					"haskell",
					"hcl",
					"html",
					"javascript",
					"jsdoc",
					"json",
					"lua",
					"markdown",
					"markdown_inline",
					"mermaid",
					"python",
					"regex",
					"sql",
					"terraform",
					"tmux",
					"toml",
					"tsx",
					"typescript",
					"xml",
					"yaml",
				},
				highlight = {
					enable = true,
					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},
				indent = {
					enable = true,
				},
			})

			-- Register markdown parser for MDX files
			vim.treesitter.language.register("markdown", "mdx")
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			keywords = {
				FIX = {
					alt = { "fixme", "fix" }, -- a set of other keywords that all map to this FIX keywords
					-- signs = false, -- configure signs for some keywords individually
				},
				TODO = { alt = { "todo" } },
			},
		},
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = function()
			require("lazy").load({ plugins = { "markdown-preview.nvim" } })
			vim.fn["mkdp#util#install"]()
		end,
		keys = {
			{
				"<leader>cp",
				ft = "markdown",
				"<cmd>MarkdownPreviewToggle<cr>",
				desc = "Markdown Preview",
			},
		},
		config = function()
			vim.cmd([[do FileType]])
		end,
	},
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xw",
				"<cmd>Trouble diagnostics toggle<CR>",
				desc = "Open trouble workspace diagnostics",
			},
			{
				"<leader>xd",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>xq",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
}
