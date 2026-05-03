return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
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
