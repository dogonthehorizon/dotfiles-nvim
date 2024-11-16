return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      extensions = {
        coc = {
          prefer_locations = true,
          push_cursor_on_edit = true,
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
          "nvim-telescope/telescope-fzf-native.nvim",
          build = "make",
          config = function()
            require('telescope').load_extension('fzf')
          end,
      },
      "fannheyward/telescope-coc.nvim",
    },
    keys = {
      {
        '<C-p>', require('telescope.builtin').git_files, desc = 'File picker'
      },
      {
        '<leader>fg', require('telescope.builtin').live_grep, desc = 'Search for symbols'
      },
      {
        '<leader>fk', require('telescope.builtin').keymaps, desc = 'Show active keymaps'
      },
      {
        '<C-k>', require('telescope.builtin').commands, desc = 'Command palette'
      },
    },
  },
}
