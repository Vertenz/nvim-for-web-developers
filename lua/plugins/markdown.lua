return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = { "markdown", "Avante" },
		opts = {
			file_types = { "markdown", "Avante" },
			completions = {
				lsp = { enabled = true },
			},
		},
		keys = {
			{
				"<leader>tm",
				"<cmd>RenderMarkdown toggle<cr>",
				desc = "Toggle Markdown preview",
			},
		},
	},
}
