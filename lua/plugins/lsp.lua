return {
  {
    "neoclide/coc.nvim",
    branch = 'master',
    lazy = false,
    build = "npm install --frozen-lockfile",
    config = function()

      vim.opt.updatetime = 300
      -- Always show the signcolumn, otherwise it would shift the text each time
      -- diagnostics appear/become resolved.
      --
      -- Useful for coc.nvim && vim-fugitive
      vim.opt.signcolumn = "yes"

      -- Define helper functions in init so they're available immediately
      function _G.check_back_space()
        local col = vim.fn.col('.') - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
      end

      function _G.show_docs()
        local cw = vim.fn.expand('<cword>')
        if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
          vim.api.nvim_command('h ' .. cw)
        elseif vim.api.nvim_eval('coc#rpc#ready()') then
          vim.fn.CocActionAsync('doHover')
        else
          vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
        end
      end

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.py",
        callback = function()
          vim.fn.CocAction('runCommand', 'python.sortImports')
        end,
      })
    end,
    keys = {
      -- Completion keys
      {
        "<TAB>",
        'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
        mode = "i",
        expr = true,
        silent = true,
        replace_keycodes = false,
      },
      {
        "<S-TAB>",
        [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]],
        mode = "i",
        expr = true,
        silent = true,
        replace_keycodes = false,
      },
      {
        "<cr>",
        [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
        mode = "i",
        expr = true,
        silent = true,
        replace_keycodes = false,
      },
      -- Diagnostic navigation
      { "[g", "<Plug>(coc-diagnostic-prev)", mode = "n", silent = true },
      { "]g", "<Plug>(coc-diagnostic-next)", mode = "n", silent = true },
      -- Code navigation
      { "gd", "<Plug>(coc-definition)", mode = "n", silent = true },
      { "gD", ":Telescope coc diagnostics<CR>", mode = "n", silent = true },
      { "gy", ":Telescope coc type_definitions<CR>", mode = "n", silent = true },
      { "gr", ":Telescope coc references<CR>", mode = "n", silent = true },
      { "gR", "<Plug>(coc-rename)", mode = "n", silent = true },
      -- Code actions
      { "<leader>ac", "<Plug>(coc-codeaction)", mode = "n", silent = true },
      { "<leader>qf", "<Plug>(coc-fix-current)", mode = "n", silent = true },
      -- Documentation
      { "K", '<CMD>lua _G.show_docs()<CR>', mode = "n", silent = true },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      laspconfig = false,
      cmp = true,
    },
  },
}
