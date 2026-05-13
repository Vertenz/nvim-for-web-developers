return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-neotest/nvim-nio",
		"nvim-treesitter/nvim-treesitter",
		"antoinemadec/FixCursorHold.nvim",
		"fredrikaverpil/neotest-golang",
	},
	cmd = "Neotest",
	keys = {
		{
			"<leader>gtt",
			function()
				require("neotest").run.run()
			end,
			desc = "[T]est nearest",
		},
		{
			"<leader>gtf",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "[T]est current [F]ile",
		},
		{
			"<leader>gtl",
			function()
				require("neotest").run.run_last()
			end,
			desc = "[T]est [L]ast",
		},
		{
			"<leader>gts",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "[T]est [S]ummary",
		},
		{
			"<leader>gto",
			function()
				require("neotest").output.open({ enter = true, auto_close = true })
			end,
			desc = "[T]est [O]utput",
		},
		{
			"<leader>gtO",
			function()
				require("neotest").output_panel.toggle()
			end,
			desc = "[T]est Output panel",
		},
		{
			"<leader>gtS",
			function()
				require("neotest").run.stop()
			end,
			desc = "[T]est [S]top",
		},
		{
			"<leader>gtd",
			function()
				require("neotest").run.run({ strategy = "dap" })
			end,
			desc = "[T]est [D]ebug nearest",
		},
		{
			"]t",
			function()
				require("neotest").jump.next({ status = "failed" })
			end,
			desc = "Next failed test",
		},
		{
			"[t",
			function()
				require("neotest").jump.prev({ status = "failed" })
			end,
			desc = "Previous failed test",
		},
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-golang")({
					runner = "gotestsum",
				}),
			},
			summary = {
				animated = false,
			},
		})
	end,
}
