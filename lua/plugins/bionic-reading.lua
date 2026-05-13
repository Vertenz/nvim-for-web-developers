return {
	"FluxxField/bionic-reading.nvim",
	cmd = { "BRToggle", "BRToggleAutoHighlight", "BRToggleUpdateInsertMode" },
	keys = {
		{ "<leader>tb", "<cmd>BRToggle<cr>", desc = "Toggle bionic reading" },
	},
	opts = {
		auto_highlight = false,
		update_in_insert_mode = false,
		file_types = {
			["markdown"] = "any",
			["text"] = "any",
			["gitcommit"] = "any",
		},
		hl_group_value = {
			link = "Bold",
		},
	},
}
