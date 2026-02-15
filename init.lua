-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Disable unused providers
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

vim.opt.clipboard:append("unnamedplus")
vim.opt.termguicolors = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

local number_augroup = vim.api.nvim_create_augroup("number-toggle", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
	group = number_augroup,
	callback = function()
		vim.opt.relativenumber = false
	end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
	group = number_augroup,
	callback = function()
		vim.opt.relativenumber = true
	end,
})

-- Autosave
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "TabLeave" }, {
	pattern = "*",
	callback = function()
		if vim.bo.modified then
			vim.cmd("silent! write")
		end
	end,
})

vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.confirm = true

-- Tabs / indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>vt", vim.diagnostic.open_float, { desc = "Show diagnostics float" })

-- Exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Spell (enhanced for dyslexia)
vim.opt.spell = true
vim.opt.spelllang = { "en_us", "ru_ru" }
vim.opt.spelloptions = "camel"
vim.opt.spellsuggest = "best,15"

-- Spell navigation keymaps (<leader>z prefix, mnemonic: z= is vim's spell suggest)
vim.keymap.set("n", "<leader>zs", function()
	vim.cmd("normal! ]s")
	vim.cmd("normal! z=")
end, { desc = "Next misspelling + suggest fix" })
vim.keymap.set("n", "<leader>zn", "]s", { desc = "Next misspelling" })
vim.keymap.set("n", "<leader>zp", "[s", { desc = "Previous misspelling" })
vim.keymap.set("n", "<leader>zf", "1z=", { desc = "Accept first spelling fix" })
vim.keymap.set("n", "<leader>za", "zg", { desc = "Add word to spellfile" })
vim.keymap.set("n", "<leader>zt", "<cmd>set spell!<cr>", { desc = "Toggle spell check" })

-- Plugins
require("config.lazy")

-- LSP configs
require("config.vue3-lsp")
require("config.lsp-config")

-- Harpoon
require("config.harpoon-setup")
