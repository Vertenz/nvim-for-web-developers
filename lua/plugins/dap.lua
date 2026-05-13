return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{
			"rcarriga/nvim-dap-ui",
			dependencies = { "nvim-neotest/nvim-nio" },
		},
		"theHamsta/nvim-dap-virtual-text",
		{
			"leoluz/nvim-dap-go",
			ft = "go",
			opts = {
				dap_configurations = {
					{
						type = "go",
						name = "Attach remote",
						mode = "remote",
						request = "attach",
					},
				},
				delve = {
					detached = vim.fn.has("win32") == 0,
				},
			},
		},
	},
	keys = {
		{
			"<F5>",
			function()
				require("dap").continue()
			end,
			desc = "Debug: continue",
		},
		{
			"<F9>",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Debug: toggle breakpoint",
		},
		{
			"<F10>",
			function()
				require("dap").step_over()
			end,
			desc = "Debug: step over",
		},
		{
			"<F11>",
			function()
				require("dap").step_into()
			end,
			desc = "Debug: step into",
		},
		{
			"<S-F11>",
			function()
				require("dap").step_out()
			end,
			desc = "Debug: step out",
		},
		{
			"<leader>gdc",
			function()
				require("dap").continue()
			end,
			desc = "[D]ebug [C]ontinue",
		},
		{
			"<leader>gdb",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "[D]ebug toggle [B]reakpoint",
		},
		{
			"<leader>gdB",
			function()
				vim.ui.input({ prompt = "Breakpoint condition: " }, function(cond)
					if cond and cond ~= "" then
						require("dap").set_breakpoint(cond)
					end
				end)
			end,
			desc = "[D]ebug conditional [B]reakpoint",
		},
		{
			"<leader>gdl",
			function()
				require("dap").run_last()
			end,
			desc = "[D]ebug run [L]ast",
		},
		{
			"<leader>gdr",
			function()
				require("dap").repl.toggle()
			end,
			desc = "[D]ebug toggle [R]EPL",
		},
		{
			"<leader>gdu",
			function()
				require("dapui").toggle()
			end,
			desc = "[D]ebug toggle [U]I",
		},
		{
			"<leader>gdt",
			function()
				require("dap-go").debug_test()
			end,
			desc = "[D]ebug Go [T]est",
		},
		{
			"<leader>gdT",
			function()
				require("dap-go").debug_last_test()
			end,
			desc = "[D]ebug Go last [T]est",
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dapui.setup({
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.5 },
						{ id = "breakpoints", size = 0.25 },
						{ id = "stacks", size = 0.25 },
					},
					position = "left",
					size = 40,
				},
				{
					elements = {
						{ id = "repl", size = 0.5 },
						{ id = "console", size = 0.5 },
					},
					position = "bottom",
					size = 10,
				},
			},
		})

		require("nvim-dap-virtual-text").setup({
			commented = true,
		})

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

		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
		vim.fn.sign_define(
			"DapBreakpointCondition",
			{ text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" }
		)
		vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
		vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual", numhl = "" })
		vim.fn.sign_define(
			"DapBreakpointRejected",
			{ text = "●", texthl = "DiagnosticHint", linehl = "", numhl = "" }
		)
	end,
}
