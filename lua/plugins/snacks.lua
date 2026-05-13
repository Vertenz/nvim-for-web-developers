return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		notifier = { enabled = true },
		quickfile = { enabled = true },
		input = { enabled = true },
		statuscolumn = { enabled = true },
		bigfile = {
			enabled = true,
			notify = true,
			size = 1.5 * 1024 * 1024,
			line_length = 800,
			setup = function(ctx)
				vim.b[ctx.buf].bigfile = true
				vim.b[ctx.buf].completion = false
				vim.b[ctx.buf].minianimate_disable = true
				vim.b[ctx.buf].minihipatterns_disable = true

				if vim.fn.exists(":NoMatchParen") ~= 0 then
					vim.cmd([[NoMatchParen]])
				end

				vim.opt_local.spell = false
				vim.opt_local.cursorline = false
				vim.opt_local.foldenable = false
				vim.opt_local.foldmethod = "manual"
				vim.opt_local.conceallevel = 0
				vim.opt_local.statuscolumn = ""

				vim.schedule(function()
					if vim.api.nvim_buf_is_valid(ctx.buf) then
						vim.bo[ctx.buf].syntax = ctx.ft
					end
				end)
			end,
		},
		dashboard = {
			enabled = true,
			width = 68,
			preset = {
				header = [[

 _   _ __     _____ __  __
| \ | |\ \   / /_ _|  \/  |
|  \| | \ \ / / | || |\/| |
| |\  |  \ V /  | || |  | |
|_| \_|   \_/  |___|_|  |_|

web + electron workspace]],
				keys = {
					{ icon = "> ", key = "f", desc = "Find file", action = ":lua Snacks.dashboard.pick('files')" },
					{
						icon = "> ",
						key = "g",
						desc = "Search text",
						action = ":lua Snacks.dashboard.pick('live_grep')",
					},
					{
						icon = "> ",
						key = "r",
						desc = "Recent files",
						action = ":lua Snacks.dashboard.pick('oldfiles')",
					},
					{
						icon = "> ",
						key = "c",
						desc = "Edit config",
						action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })",
					},
					{ icon = "> ", key = "n", desc = "New file", action = ":ene | startinsert" },
					{ icon = "> ", key = "l", desc = "Lazy plugins", action = ":Lazy" },
					{ icon = "> ", key = "h", desc = "Health check", action = ":checkhealth" },
					{ icon = "> ", key = "q", desc = "Quit", action = ":qa" },
				},
			},
			sections = {
				{ section = "header" },
				{
					section = "terminal",
					cmd = "printf 'project: %s\\n' \"${PWD##*/}\"; date '+today:  %a %d %b %H:%M'",
					height = 2,
					padding = 2,
				},
				{ section = "keys", gap = 1, padding = 1 },
				{ icon = "- ", title = "Recent Projects", section = "projects", indent = 2, padding = 1 },
				{ icon = "- ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
				{ section = "startup" },
			},
		},
	},
}
