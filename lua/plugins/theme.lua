return {
	{
		"catppuccin/nvim",
		priority = 1000,
		name = "catppuccin",
		opts = {
			flavour = "macchiato",
			dim_inactive = {
				enabled = true,
				percentage = 0.20,
			},
		},
		init = function()
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	"nvim-tree/nvim-web-devicons",
}
