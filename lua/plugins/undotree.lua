vim.keymap.set("n", "<C-U>", function()
	vim.cmd("packadd nvim.undotree")
	require("undotree").open()
end, { desc = "Toggle Undotree" })

return {}
