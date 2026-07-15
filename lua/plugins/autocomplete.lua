return {
	"saghen/blink.cmp",
	dependencies = { "rafamadriz/friendly-snippets" },
	event = { "CmdlineEnter", "InsertEnter" },
	version = "1.*",

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = { preset = "default" },

		appearance = {
			nerd_font_variant = "mono",
		},

		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 300,
			},
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			per_filetype = {
				sql = { inherit_defaults = true, "dadbod" },
				mysql = { inherit_defaults = true, "dadbod" },
				plsql = { inherit_defaults = true, "dadbod" },
			},
			providers = {
				-- Show the menu without waiting on slow clients (vue_ls/tailwindcss);
				-- late responders are merged in asynchronously after the timeout.
				lsp = { timeout_ms = 500 },
				buffer = { score_offset = -5 },
				dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
			},
		},

		signature = { enabled = true },

		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
