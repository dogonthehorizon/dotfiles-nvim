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
  "tpope/vim-surround",
  "tpope/vim-vinegar",
  "tpope/vim-obsession",
  {
    "lukas-reineke/indent-blankline.nvim", -- Using the recommended replacement
    main = "ibl",
    opts = {}  -- Using default options, customize as needed
  },

  {
    "hiphish/rainbow-delimiters.nvim",
    lazy = false,
    init = function()
      require('rainbow-delimiters')
      require('rainbow-delimiters.setup').setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = {
          'lua', 'python', 'typescript', 'regex', 'bash', 'fish', 'markdown',
          'markdown_inline', 'sql', 'json', 'html', 'css', 'javascript',
          'typescript', 'yaml', 'json', 'toml', 'haskell', 'dockerfile',
          'git_config', 'git_rebase', 'gitattributes', 'gitcommit',
          'gitignore', 'go', 'gomod', 'gosum', 'hcl', 'jsdoc', 'mermaid',
          'tmux', 'tsx', 'xml'
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
            enable = true
          }
      })

      -- Register markdown parser for MDX files
      vim.treesitter.language.register('markdown', 'mdx')
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        theme = 'catppuccin',
        component_separators = '|',
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_x = { 'g:coc_status' }
      }
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require('todo-comments').setup({
        keywords = {
          FIX = {
            alt = { "fixme", "fix" }, -- a set of other keywords that all map to this FIX keywords
            -- signs = false, -- configure signs for some keywords individually
          },
          TODO = { alt = { "todo" } },
        }
      })
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end
  },
}
