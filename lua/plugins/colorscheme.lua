return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	keys = {
		{ "<leader>tt", function() require("config.theme").toggle() end, desc = "Toggle theme" },
	},
	config = function()
		require("tokyonight").setup({
			styles = {
				comments = { italic = false },
			},
		})
		require("config.theme").setup()
	end,
}
