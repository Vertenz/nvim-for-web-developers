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
			"terraform",
			"hcl",
			"prisma",
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

		-- Neovim 0.12 passes directive captures as capture_id -> TSNode[].
		-- Some nvim-treesitter directives still expect the older single-node shape.
		local query = require("vim.treesitter.query")
		local function first_node(match, capture_id)
			local node = match[capture_id]
			if type(node) == "table" and node.range == nil then
				return node[1]
			end
			return node
		end
		local function lang_from_info_string(lang)
			local aliases = {
				ex = "elixir",
				pl = "perl",
				sh = "bash",
				ts = "typescript",
				uxn = "uxntal",
			}
			return vim.filetype.match({ filename = "a." .. lang }) or aliases[lang] or lang
		end
		query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
			local node = first_node(match, pred[2])
			if not node then
				return
			end
			local lang = vim.treesitter.get_node_text(node, bufnr):lower()
			metadata["injection.language"] = lang_from_info_string(lang)
		end, { force = true })
		query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
			local node = first_node(match, pred[2])
			if not node then
				return
			end
			local mime = vim.treesitter.get_node_text(node, bufnr)
			local configured = ({
				importmap = "json",
				module = "javascript",
				["application/ecmascript"] = "javascript",
				["text/ecmascript"] = "javascript",
			})[mime]
			local parts = vim.split(mime, "/", {})
			metadata["injection.language"] = configured or parts[#parts]
		end, { force = true })

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
