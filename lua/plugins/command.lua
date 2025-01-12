return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				config = function()
					require("telescope").load_extension("fzf")
				end,
			},
			"folke/todo-comments.nvim",
		},
		keys = {
			{
				"<C-p>",
				require("telescope.builtin").git_files,
				desc = "File picker",
			},
			{
				"<leader>fg",
				require("telescope.builtin").live_grep,
				desc = "Search for symbols",
			},
			{
				"<leader>fk",
				require("telescope.builtin").keymaps,
				desc = "Show active keymaps",
			},
			{
				"<C-k>",
				require("telescope.builtin").commands,
				desc = "Command palette",
			},
			{
				"<leader>ft",
				"<cmd>TodoTelescope<CR>",
				desc = "Find todos",
			},
		},
	},
}
