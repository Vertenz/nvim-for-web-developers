return {
	{
		"MeanderingProgrammer/markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
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
				"<cmd>RenderMarkdownToggle<cr>",
				desc = "Toggle Markdown preview",
			},
		},
	},
}
