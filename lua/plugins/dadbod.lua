return {
	{
		"tpope/vim-dadbod",
		cmd = "DB",
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			"tpope/vim-dadbod",
		},
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
		keys = {
			{ "<leader>db", "<cmd>DBUIToggle<cr>", desc = "Toggle DB UI" },
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = vim.g.have_nerd_font and 1 or 0
			vim.g.db_ui_execute_on_save = 0
			vim.g.db_ui_hide_schemas = { "^pg_", "^information_schema$", "^pg_toast" }
		end,
	},
	{
		"kristijanhusak/vim-dadbod-completion",
		dependencies = {
			"tpope/vim-dadbod",
			"kristijanhusak/vim-dadbod-ui",
		},
		ft = { "sql", "mysql", "plsql" },
	},
}
