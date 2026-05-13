return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			completions = {
				lsp = { enabled = true },
			},
		},
		ft = { "markdown" },
		keys = {
			{
				"<leader>tm",
				"<cmd>RenderMarkdown toggle<cr>",
				desc = "Toggle Markdown preview",
			},
		},
	},
}
