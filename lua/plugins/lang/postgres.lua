local function setup_dbui()
	local M = {}

	-- Store the DBUI state
	M.state = {
		dbui_bufname = "dbui", -- The name of the DBUI buffer
		is_closing = false, -- Flag to prevent recursive closing
	}

	-- Find the DBUI tab and buffer if they exist
	function M.find_dbui()
		for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
			local wins = vim.api.nvim_tabpage_list_wins(tab)
			for _, win in ipairs(wins) do
				local buf = vim.api.nvim_win_get_buf(win)
				local buf_name = vim.api.nvim_buf_get_name(buf)
				if buf_name:match("dbui$") then
					return {
						tab = tab,
						win = win,
						buf = buf,
					}
				end
			end
		end
		return nil
	end

	-- Create a new tab with DBUI
	function M.create_dbui()
		vim.cmd("tabnew")
		vim.cmd("DBUI")
		return M.find_dbui()
	end

	-- Close DBUI tab safely
	function M.close_dbui(dbui)
		if M.state.is_closing then
			return
		end
		M.state.is_closing = true

		-- Switch to DBUI tab and close it
		vim.api.nvim_set_current_tabpage(dbui.tab)
		vim.cmd("tabclose")

		M.state.is_closing = false
	end

	-- Toggle DBUI function
	function M.toggle_dbui()
		local dbui = M.find_dbui()
		local current_tab = vim.api.nvim_get_current_tabpage()

		if dbui then
			if dbui.tab == current_tab then
				M.close_dbui(dbui)
			else
				vim.api.nvim_set_current_tabpage(dbui.tab)
			end
		else
			M.create_dbui()
		end
	end

	return M
end

-- NOTE: db configurations are managed per workspace, so you'll need to add
-- .nvim.lua in the root of the project and configure db connections.
--
-- Here's an example:
--
--[=====[ 
-- file: workspace/.nvim.lua

local aws = require("config.functions")

local agent_db_pw = aws.get_secret_value(
	"arn:aws:secretsmanager:us-west-2::secret:my-secret-arn",
	{ profile = "teem-cfo", region = "us-west-2" }
)

vim.g.dbs = {
	{
		name = "agent-db",
		url = "postgres://my_user:"
			.. agent_db_pw["password"]
			.. "@my_db_ur/my_db",
	},
}
--]=====]
return {
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		keys = {
			{
				"<leader>db",
				function()
					local dbui = setup_dbui()
					dbui.toggle_dbui()
				end,
				desc = "Toggle DBUI in new tab",
			},
		},
		init = function()
			-- Your DBUI configuration
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_disable_info_notifications = 1
		end,
	},
}
