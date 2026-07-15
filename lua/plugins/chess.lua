return {
	{
		"linuxswords/nvim-chess",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			lichess = {
				-- token = "your_lichess_token_here", -- Your Lichess personal access token (optional)
				timeout = 30000, -- Request timeout in milliseconds
			},
			ui = {
				puzzle_window_mode = "split",
			},
		},
	},
}
