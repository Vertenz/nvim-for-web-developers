return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			completions = {
				lsp = { enabled = true },
			},
			toc = {
				enabled = true,
				max_level = 3,
			},
			codeblock = {
				highlight = true,
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
