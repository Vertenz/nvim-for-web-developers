return {
	"FluxxField/bionic-reading.nvim",
	cmd = { "BRToggle", "BROn", "BROff" },
	keys = {
		{ "<leader>tb", "<cmd>BRToggle<cr>", desc = "Toggle bionic reading" },
	},
	opts = {
		auto_highlight = false,
		file_types = {
			"markdown",
			"text",
			"gitcommit",
		},
		hl_group_value = {
			link = "Bold",
		},
	},
}
