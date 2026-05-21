local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn", "info", "hint" },
	symbols = {
		error = "E:",
		warn = "W:",
		info = "I:",
		hint = "H:",
	},
	diagnostics_color = {
		error = "DiagnosticError",
		warn = "DiagnosticWarn",
		info = "DiagnosticInfo",
		hint = "DiagnosticHint",
	},
	colored = true,
	update_in_insert = false,
	always_visible = false,
}

return {
	"nvim-lualine/lualine.nvim",
	event = "VimEnter",
	opts = {
		options = {
			theme = "auto",
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", diagnostics },
			lualine_c = { { "filename", path = 1 } },
			lualine_x = { "encoding", "fileformat", "filetype" },
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
	},
}
