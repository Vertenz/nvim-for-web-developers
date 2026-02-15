local harpoon = require("harpoon")

harpoon:setup()

vim.keymap.set("n", "<leader>ha", function()
	harpoon:list():add()
end, { desc = "Add file to harpoon" })

vim.keymap.set("n", "<leader>hh", function()
	local conf = require("telescope.config").values
	local file_paths = {}
	for _, item in ipairs(harpoon:list().items) do
		table.insert(file_paths, item.value)
	end
	require("telescope.pickers")
		.new({}, {
			prompt_title = "Harpoon",
			finder = require("telescope.finders").new_table({ results = file_paths }),
			previewer = conf.file_previewer({}),
			sorter = conf.generic_sorter({}),
		})
		:find()
end, { desc = "Open harpoon list" })

vim.keymap.set("n", "<leader>hp", function()
	harpoon:list():prev()
end, { desc = "Go to previous harpoon file" })

vim.keymap.set("n", "<leader>hn", function()
	harpoon:list():next()
end, { desc = "Go to next harpoon file" })

vim.keymap.set("n", "<leader>hr", function()
	harpoon:list():remove()
end, { desc = "Remove file from harpoon" })

vim.keymap.set("n", "<leader>hc", function()
	harpoon:list():clear()
end, { desc = "Clear harpoon list" })

-- Quick file access by index
for i = 1, 4 do
	vim.keymap.set("n", "<leader>h" .. i, function()
		harpoon:list():select(i)
	end, { desc = "Harpoon file " .. i })
end
