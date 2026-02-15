return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	opts = {
		ensure_installed = {
			"bash",
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
			"vue",
			"javascript",
			"typescript",
			"tsx",
			"scss",
			"css",
			"python",
			"json",
			"jsonc",
			"yaml",
			"toml",
			"dockerfile",
			"sql",
			"helm",
			"regex",
		},
		auto_install = true,
		sync_install = false,
		highlight = { enable = true, additional_vim_regex_highlighting = false },
		indent = { enable = true },
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = { query = "@function.outer", desc = "Select outer function" },
					["if"] = { query = "@function.inner", desc = "Select inner function" },
					["ac"] = { query = "@class.outer", desc = "Select outer class" },
					["ic"] = { query = "@class.inner", desc = "Select inner class" },
					["aa"] = { query = "@parameter.outer", desc = "Select outer argument" },
					["ia"] = { query = "@parameter.inner", desc = "Select inner argument" },
				},
			},
			move = {
				enable = true,
				set_jumps = true,
				goto_next_start = {
					["]m"] = { query = "@function.outer", desc = "Next function start" },
					["]]"] = { query = "@class.outer", desc = "Next class start" },
				},
				goto_next_end = {
					["]M"] = { query = "@function.outer", desc = "Next function end" },
					["]["] = { query = "@class.outer", desc = "Next class end" },
				},
				goto_previous_start = {
					["[m"] = { query = "@function.outer", desc = "Previous function start" },
					["[["] = { query = "@class.outer", desc = "Previous class start" },
				},
				goto_previous_end = {
					["[M"] = { query = "@function.outer", desc = "Previous function end" },
					["[]"] = { query = "@class.outer", desc = "Previous class end" },
				},
			},
			swap = {
				enable = true,
				swap_next = {
					["<leader>sa"] = { query = "@parameter.inner", desc = "Swap with next argument" },
				},
				swap_previous = {
					["<leader>sA"] = { query = "@parameter.inner", desc = "Swap with previous argument" },
				},
			},
		},
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
		vim.opt.foldenable = true
		vim.opt.foldlevel = 99

		local km = vim.keymap.set
		km("n", "<leader>ws", "zc", { desc = "Close fold" })
		km("n", "<leader>we", "zo", { desc = "Open fold" })
		km("n", "<leader>wS", "zM", { desc = "Close all folds" })
		km("n", "<leader>wE", "zR", { desc = "Open all folds" })
		km("n", "]f", "]z", { desc = "Next fold" })
		km("n", "[f", "[z", { desc = "Previous fold" })
	end,
}
