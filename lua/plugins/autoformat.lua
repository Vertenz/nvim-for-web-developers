local prettier_filetypes = {
	javascript = true,
	typescript = true,
	typescriptreact = true,
	javascriptreact = true,
	vue = true,
	json = true,
	jsonc = true,
	html = true,
	css = true,
	scss = true,
	less = true,
	postcss = true,
	markdown = true,
	yaml = true,
}

local eslint_filetypes = {
	javascript = true,
	typescript = true,
	typescriptreact = true,
	javascriptreact = true,
	vue = true,
}

local stylelint_filetypes = {
	vue = true,
	css = true,
	scss = true,
	less = true,
	postcss = true,
}

local format_timeout_ms = 5000

local function package_root_from_path(path)
	if not path or path == "" then
		return nil
	end

	local stat = vim.uv.fs_stat(path)
	local start = stat and stat.type == "directory" and path or vim.fs.dirname(path)
	return start and vim.fs.root(start, { "package.json" }) or nil
end

local function local_node_bin(root, bin)
	if not root then
		return nil
	end

	local command = root .. "/node_modules/.bin/" .. bin
	return vim.fn.executable(command) == 1 and command or nil
end

local function local_prettier_for_buf(bufnr)
	return local_node_bin(package_root_from_path(vim.api.nvim_buf_get_name(bufnr)), "prettier")
end

local function local_prettier_for_ctx(ctx)
	return local_node_bin(package_root_from_path(ctx.dirname), "prettier")
end

local function local_eslint_for_buf(bufnr)
	return local_node_bin(package_root_from_path(vim.api.nvim_buf_get_name(bufnr)), "eslint")
end

local function local_eslint_for_ctx(ctx)
	return local_node_bin(package_root_from_path(ctx.dirname), "eslint")
end

local function local_stylelint_for_buf(bufnr)
	return local_node_bin(package_root_from_path(vim.api.nvim_buf_get_name(bufnr)), "stylelint")
end

local function local_stylelint_for_ctx(ctx)
	return local_node_bin(package_root_from_path(ctx.dirname), "stylelint")
end

local function has_local_web_formatter(bufnr, filetype)
	return (prettier_filetypes[filetype] and local_prettier_for_buf(bufnr))
		or (eslint_filetypes[filetype] and local_eslint_for_buf(bufnr))
		or (stylelint_filetypes[filetype] and local_stylelint_for_buf(bufnr))
end

local function split_lines(text)
	local lines = vim.split(text, "\n", { plain = true })
	if lines[#lines] == "" then
		table.remove(lines)
	end
	return lines
end

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				local bufnr = vim.api.nvim_get_current_buf()
				local filetype = vim.bo[bufnr].filetype

				if prettier_filetypes[filetype] and not has_local_web_formatter(bufnr, filetype) then
					return
				end

				require("conform").format({
					async = true,
					lsp_format = prettier_filetypes[filetype] and "never" or "fallback",
				})
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			local max_format_size = 300 * 1024
			local max_format_lines = 5000
			local filename = vim.api.nvim_buf_get_name(bufnr)
			local stat = filename ~= "" and vim.uv.fs_stat(filename) or nil
			local filetype = vim.bo[bufnr].filetype
			local line_count = vim.api.nvim_buf_line_count(bufnr)

			if vim.b[bufnr].bigfile or line_count > max_format_lines then
				return nil
			end

			if stat and stat.size > max_format_size then
				return nil
			end

			if
				(filetype == "json" or filetype == "jsonc") and (line_count > 1000 or (stat and stat.size > 100 * 1024))
			then
				return nil
			end

			local disable_filetypes = { c = true, cpp = true }
			if disable_filetypes[filetype] then
				return nil
			end

			if prettier_filetypes[filetype] and not has_local_web_formatter(bufnr, filetype) then
				return nil
			end

			return {
				timeout_ms = format_timeout_ms,
				lsp_format = prettier_filetypes[filetype] and "never" or "fallback",
			}
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_organize_imports", "ruff_format" },
			go = { "goimports", "gofumpt" },
			terraform = { "terraform_fmt" },
			["terraform-vars"] = { "terraform_fmt" },
			sql = { "sqlfluff", "sql_formatter_postgres", stop_after_first = true },
			javascript = { "eslint_fix", "prettier" },
			typescript = { "eslint_fix", "prettier" },
			typescriptreact = { "eslint_fix", "prettier" },
			javascriptreact = { "eslint_fix", "prettier" },
			vue = { "eslint_fix", "stylelint", "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			html = { "prettier" },
			css = { "stylelint", "prettier" },
			scss = { "stylelint", "prettier" },
			less = { "stylelint", "prettier" },
			postcss = { "stylelint", "prettier" },
			markdown = { "prettier" },
			yaml = { "prettier" },
		},
		formatters = {
			eslint_fix = {
				format = function(_, ctx, lines, callback)
					local command = local_eslint_for_ctx(ctx)
					local root = package_root_from_path(ctx.dirname)
					if not command or not root then
						callback(nil, nil)
						return
					end

					local result = vim.system({
						command,
						"--fix-dry-run",
						"--format",
						"json",
						"--stdin",
						"--stdin-filename",
						ctx.filename,
					}, {
						cwd = root,
						stdin = table.concat(lines, "\n"),
						text = true,
					}):wait(5000) -- kill eslint instead of blocking the UI indefinitely

					local ok, decoded = pcall(vim.json.decode, result.stdout or "")
					local fixed = ok and decoded and decoded[1] and decoded[1].output
					callback(nil, fixed and split_lines(fixed) or nil)
				end,
				condition = function(_, ctx)
					return local_eslint_for_ctx(ctx) ~= nil
				end,
			},
			prettier = {
				command = function(_, ctx)
					return local_prettier_for_ctx(ctx) or "prettier"
				end,
				condition = function(_, ctx)
					return local_prettier_for_ctx(ctx) ~= nil
				end,
				cwd = function(_, ctx)
					return package_root_from_path(ctx.dirname)
				end,
				require_cwd = true,
			},
			stylelint = {
				command = function(_, ctx)
					return local_stylelint_for_ctx(ctx) or "stylelint"
				end,
				condition = function(_, ctx)
					return local_stylelint_for_ctx(ctx) ~= nil
				end,
				cwd = function(_, ctx)
					return package_root_from_path(ctx.dirname)
				end,
				require_cwd = true,
			},
			sql_formatter_postgres = {
				command = "sql-formatter",
				args = { "--language", "postgresql" },
			},
		},
	},
}
