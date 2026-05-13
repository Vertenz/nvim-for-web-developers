return {
	"folke/todo-comments.nvim",
	event = { "BufReadPost", "BufNewFile" },
	cmd = { "TodoQuickFix", "TodoLocList", "TodoTelescope" },
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = { signs = false },
}
