return {
  {
    "tpope/vim-fugitive",
    dependencies = {
      {
        "airblade/vim-gitgutter",
        lazy = false
      },
    },
    keys = {
      { "<leader>gs", ":Git<CR>", desc = "Git status" },
      { "<leader>gd", ":Gdiff<CR>", desc = "Git diff" },
      { "<leader>gc", ":Git commit --verbose<CR>", desc = "Git commit" },
      { "<leader>gb", ":Git blame<CR>", desc = "Git blame" },
      { "<leader>gl", ":Git log<CR>", desc = "Git log" },
      { "<leader>gp", ":Git push<CR>", desc = "Git push" },
    },
  },
}
