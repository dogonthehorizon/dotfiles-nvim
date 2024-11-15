return {
  {
    "nvim-lua/plenary.nvim"
  },
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
      {
          "nvim-telescope/telescope-fzf-native.nvim",
          build = "make",
          config = function()
            require('telescope').load_extension('fzf')
          end,
      },
    },
    keys = {
      {
        '<C-p>',
        function()
          require('telescope.builtin').find_files()
        end,
      },
      {
        '<leader>fg',
        function()
          require('telescope.builtin').live_grep()
        end,
      },
    },
  },
  {
    "fannheyward/telescope-coc.nvim"
  },
}
