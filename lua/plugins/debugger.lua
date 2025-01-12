return {
	-- Debugging
	{
		"mfussenegger/nvim-dap",
		keys = {
			{
				"<F5>",
				function()
					require("dap").continue()
				end,
				desc = "DAP: Continue",
			},
			{
				"<F10>",
				function()
					require("dap").step_over()
				end,
				desc = "DAP: Step Over",
			},
			{
				"<F11>",
				function()
					require("dap").step_into()
				end,
				desc = "DAP: Step Into",
			},
			{
				"<F12>",
				function()
					require("dap").step_out()
				end,
				desc = "DAP: Step Out",
			},
			{
				"<leader>b",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "DAP: Toggle Breakpoint",
			},
			{
				"<leader>B",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "DAP: Set Conditional Breakpoint",
			},
			{
				"<leader>lp",
				function()
					require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
				end,
				desc = "DAP: Set Log Point",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.open()
				end,
				desc = "DAP: Open REPL",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "DAP: Run Last",
			},
			{
				"<leader>dc",
				function()
					require("dapui").close()
				end,
				desc = "DAP: Close UI",
			},
		},
		dependencies = {
			"nvim-neotest/nvim-nio",
			"mxsdev/nvim-dap-vscode-js",
			{
				"rcarriga/nvim-dap-ui",
				config = function()
					local dap = require("dap")
					-- DAP UI setup
					local dapui = require("dapui")
					dapui.setup()

					-- Setup DAP UI auto open/close
					dap.listeners.before.attach.dapui_config = function()
						dapui.open()
					end
					dap.listeners.before.launch.dapui_config = function()
						dapui.open()
					end
					dap.listeners.before.event_terminated.dapui_config = function()
						dapui.close()
					end
					dap.listeners.before.event_exited.dapui_config = function()
						dapui.close()
					end
				end,
			},
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			local dap = require("dap")

			-- Setup JS debugging
			require("dap-vscode-js").setup({
				debugger_path = vim.fn.stdpath("config") .. "/pack/minpac/start/vscode-js-debug",
				adapters = { "pwa-node", "pwa-chrome" },
			})

			-- Add configurations for JavaScript/TypeScript debugging
			for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "typescript.tsx" }) do
				dap.configurations[language] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "dap - nextjs server side",
						cwd = "${workspaceFolder}",
						runtimeExecutable = "npm",
						runtimeArgs = { "run", "dev", "--turbo" },
						skipFiles = { "<node_internals>/**" },
						console = "integratedTerminal",
					},
					{
						type = "pwa-chrome",
						request = "launch",
						name = "dap - nextjs client side",
						url = "http://localhost:3000",
						webRoot = "${workspaceFolder}",
						skipFiles = { "<node_internals>/**" },
					},
				}
			end
		end,
	},
}
