local M = {}

M.themes = {
	dark = {
		colorscheme = "tokyonight-storm",
		background = "dark",
	},
	light = {
		colorscheme = "tokyonight-day",
		background = "light",
	},
}

local state_file = vim.fn.stdpath("state") .. "/theme"

local function normalize(mode)
	if M.themes[mode] then
		return mode
	end

	for name, theme in pairs(M.themes) do
		if theme.colorscheme == mode then
			return name
		end
	end
end

local function refresh_lualine()
	local ok, lualine = pcall(require, "lualine")
	if ok then
		lualine.refresh()
	end
end

function M.current()
	return normalize(vim.g.theme_mode) or "dark"
end

function M.load()
	local ok, lines = pcall(vim.fn.readfile, state_file)
	if not ok or not lines[1] then
		return "dark"
	end

	return normalize(vim.trim(lines[1])) or "dark"
end

function M.save(mode)
	local ok = pcall(vim.fn.mkdir, vim.fn.fnamemodify(state_file, ":h"), "p")
	if ok then
		pcall(vim.fn.writefile, { mode }, state_file)
	end
end

function M.apply(mode, opts)
	opts = opts or {}
	mode = normalize(mode) or "dark"

	local theme = M.themes[mode]
	vim.opt.background = theme.background
	vim.g.theme_mode = mode
	vim.cmd.colorscheme(theme.colorscheme)

	if opts.save ~= false then
		M.save(mode)
	end

	refresh_lualine()
	if opts.notify ~= false then
		vim.notify("Theme: " .. mode, vim.log.levels.INFO)
	end
end

function M.toggle()
	M.apply(M.current() == "dark" and "light" or "dark")
end

function M.setup()
	M.apply(M.load(), { save = false, notify = false })

	vim.api.nvim_create_user_command("ThemeDark", function()
		M.apply("dark")
	end, { desc = "Switch to dark theme" })

	vim.api.nvim_create_user_command("ThemeLight", function()
		M.apply("light")
	end, { desc = "Switch to light theme" })

	vim.api.nvim_create_user_command("ThemeToggle", function()
		M.toggle()
	end, { desc = "Toggle light/dark theme" })
end

return M
