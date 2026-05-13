return {
	{
		"brenoprata10/nvim-highlight-colors",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("nvim-highlight-colors").setup({
				render = "background",
				enable_var_usage = true,
				exclude_buffer = function(bufnr)
					local name = vim.api.nvim_buf_get_name(bufnr)
					if name == "" then
						return false
					end
					local size = vim.fn.getfsize(name)
					return size and size > 1024 * 1024
				end,
			})
		end,
	},
}
