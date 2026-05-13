return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		indent = {
			char = "│",
			tab_char = "│",
		},
		scope = {
			enabled = true,
			show_start = false,
			show_end = false,
		},
		exclude = {
			filetypes = {
				"help",
				"lazy",
				"mason",
				"snacks_dashboard",
				"snacks_notif",
				"snacks_terminal",
				"snacks_win",
			},
			buftypes = { "terminal", "quickfix", "nofile" },
		},
	},
}
