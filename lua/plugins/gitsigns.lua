return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
		signs_staged = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
		attach_to_untracked = true,
		current_line_blame = true,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			delay = 350,
			ignore_whitespace = false,
		},
		current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
		current_line_blame_formatter_nc = "<author>",
		on_attach = function(bufnr)
			local gs = require("gitsigns")
			local function map(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
			end

			map("n", "]c", function()
				gs.nav_hunk("next")
			end, "Next hunk")
			map("n", "[c", function()
				gs.nav_hunk("prev")
			end, "Prev hunk")

			map("n", "<leader>Hs", gs.stage_hunk, "Stage hunk")
			map("n", "<leader>Hr", gs.reset_hunk, "Reset hunk")
			map("v", "<leader>Hs", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Stage hunk")
			map("v", "<leader>Hr", function()
				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Reset hunk")
			map("n", "<leader>HS", gs.stage_buffer, "Stage buffer")
			map("n", "<leader>HR", gs.reset_buffer, "Reset buffer")
			map("n", "<leader>Hp", gs.preview_hunk, "Preview hunk")
			map("n", "<leader>Hb", function()
				gs.blame_line({ full = true })
			end, "Blame line (full)")
			map("n", "<leader>HB", gs.toggle_current_line_blame, "Toggle line blame")
			map("n", "<leader>Hd", gs.diffthis, "Diff against index")

			map({ "o", "x" }, "ih", "<cmd>Gitsigns select_hunk<cr>", "Select hunk")
		end,
	},
}
