return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	cmd = { "NvimTreeFindFile", "NvimTreeFocus", "NvimTreeOpen", "NvimTreeToggle" },
	keys = {
		{ "<C-n>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
	},
	init = function()
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function(data)
				if vim.fn.isdirectory(data.file) == 1 then
					require("lazy").load({ plugins = { "nvim-tree.lua" } })
					vim.cmd.cd(data.file)
					require("nvim-tree.api").tree.open()
				end
			end,
		})
	end,
	config = function()
		require("nvim-tree").setup({
			sort = {
				sorter = "case_sensitive",
			},
			view = {
				width = 50,
				side = "left",
				preserve_window_proportions = true,
				number = true,
				relativenumber = true,
			},
			renderer = {
				group_empty = true,
				highlight_opened_files = "all",
				highlight_git = "name",
				icons = {
					show = {
						file = true,
						folder = true,
						folder_arrow = true,
						git = true,
					},
				},
			},
			filters = {
				dotfiles = false,
				custom = { ".DS_Store" },
			},
			git = {
				enable = true,
				ignore = false,
			},
			actions = {
				open_file = {
					quit_on_open = true,
					resize_window = true,
				},
			},
		})
	end,
}
