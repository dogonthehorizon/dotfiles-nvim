return {
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false,
		build = "make",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
		opts = {
			provider = "claude",
			claude = {
				api_key_name = "cmd:bw get password console.anthropic.com",
				model = "claude-3-5-sonnet-20241022",
			},
			mappings = {
				files = {
					add_current = "<leader>aF",
				},
			},
			file_selector = {
				provider = "telescope",
			},
			behaviour = {
				auto_focus_sidebar = false,
			},
		},
	},
	{
		"dogonthehorizon/nvim-model-context-protocol",
		dir = "/Users/ffreire/git/dogonthehorizon/nvim-model-context-protocol",
		build = "python3 -m venv .venv || true && source .venv/bin/activate.fish && pip install -r requirements.txt",
		init = function() end,
	},
}
