return {
  {
    "catppuccin/nvim",
    priority = 1000,
    name = "catppuccin",
    opts = {
      flavour = 'mocha',
      dim_inactive = {
        enabled = true,
        percentage = 0.30,
      },
      integrations = {
        coc_nvim = true
      },
    },
    init = function()
        vim.cmd.colorscheme 'catppuccin'
    end,
  },
  "nvim-tree/nvim-web-devicons",
}
