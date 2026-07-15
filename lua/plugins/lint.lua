return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		local golangci_lint_timeout = "5m"
		local go_bin = "/usr/local/go/bin"
		if vim.fn.executable(go_bin .. "/go") == 1 and not string.find(vim.env.PATH, go_bin, 1, true) then
			vim.env.PATH = go_bin .. ":" .. vim.env.PATH
		end

		local linters_by_ft = {
			markdown = { "markdownlint" },
			sql = { "sqlfluff" },
			terraform = { "tflint" },
			go = { "golangcilint" },
			javascript = { "eslint" },
			typescript = { "eslint" },
			javascriptreact = { "eslint" },
			typescriptreact = { "eslint" },
			vue = { "eslint" },
		}
		lint.linters_by_ft = linters_by_ft

		local function package_root(bufnr)
			local filename = vim.api.nvim_buf_get_name(bufnr)
			if filename == "" then
				return nil
			end

			return vim.fs.root(vim.fs.dirname(filename), { "package.json" })
		end

		local function root_from_markers(bufnr, markers)
			local filename = vim.api.nvim_buf_get_name(bufnr)
			if filename == "" then
				return nil
			end

			return vim.fs.root(vim.fs.dirname(filename), markers)
		end

		local function has_local_node_bin(bufnr, bin)
			local root = package_root(bufnr)
			if not root then
				return false
			end

			return vim.fn.executable(root .. "/node_modules/.bin/" .. bin) == 1
		end

		local function local_node_bin_for_current_buf(bin)
			local root = package_root(0)
			if not root then
				return nil
			end

			local command = root .. "/node_modules/.bin/" .. bin
			return vim.fn.executable(command) == 1 and command or nil
		end

		local function sqlfluff_root(bufnr)
			return root_from_markers(bufnr, { ".sqlfluff", "pyproject.toml", "setup.cfg", "tox.ini", "pep8.ini" })
		end

		local function go_root(bufnr)
			return root_from_markers(
				bufnr,
				{ "go.mod", "go.work", ".golangci.yml", ".golangci.yaml", ".golangci.toml" }
			)
		end

		lint.linters.eslint.cmd = function()
			return local_node_bin_for_current_buf("eslint") or "eslint"
		end

		lint.linters.markdownlint.cmd = function()
			return local_node_bin_for_current_buf("markdownlint") or "markdownlint"
		end

		lint.linters.golangcilint.cmd = function()
			local command = vim.fn.exepath("golangci-lint")
			return command ~= "" and command or "golangci-lint"
		end
		lint.linters.golangcilint.args = {
			"run",
			"--allow-parallel-runners",
			"--output.json.path=stdout",
			"--output.text.path=",
			"--output.tab.path=",
			"--output.html.path=",
			"--output.checkstyle.path=",
			"--output.code-climate.path=",
			"--output.junit-xml.path=",
			"--output.teamcity.path=",
			"--output.sarif.path=",
			"--issues-exit-code=0",
			"--show-stats=false",
			"--timeout=" .. golangci_lint_timeout,
			"--path-mode=abs",
			function()
				local go_mod = vim.fn.system({ "go", "env", "GOMOD" }):gsub("%s+", "")
				local filename_modifier = (go_mod == "" or go_mod == "/dev/null") and ":p" or ":h"
				return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), filename_modifier)
			end,
		}
		local golangci_parser = lint.linters.golangcilint.parser
		lint.linters.golangcilint.parser = function(output, bufnr, cwd)
			local ok, diagnostics = pcall(golangci_parser, output, bufnr, cwd)
			if ok then
				return diagnostics
			end
			vim.schedule(function()
				vim.notify("golangci-lint returned non-JSON output; check :messages", vim.log.levels.WARN)
			end)
			return {}
		end

		lint.linters.sqlfluff.args = {
			"lint",
			"--dialect",
			"postgres",
			"--format=json",
			"-",
		}

		local function available_linters(bufnr)
			local names = linters_by_ft[vim.bo[bufnr].filetype] or {}
			local available = {}

			for _, name in ipairs(names) do
				if name == "eslint" then
					if has_local_node_bin(bufnr, "eslint") then
						table.insert(available, "eslint")
					end
				elseif name == "markdownlint" then
					if has_local_node_bin(bufnr, "markdownlint") then
						table.insert(available, name)
					end
				elseif name == "sqlfluff" then
					if vim.fn.executable("sqlfluff") == 1 then
						table.insert(available, name)
					end
				elseif name == "tflint" then
					if vim.fn.executable("tflint") == 1 then
						table.insert(available, name)
					end
				elseif name == "golangcilint" then
					if vim.fn.executable("golangci-lint") == 1 then
						table.insert(available, name)
					end
				else
					table.insert(available, name)
				end
			end

			return available
		end

		local function lint_cwd(bufnr, linters)
			if vim.tbl_contains(linters, "sqlfluff") then
				return sqlfluff_root(bufnr)
			end

			if vim.tbl_contains(linters, "golangcilint") then
				return go_root(bufnr)
			end

			return package_root(bufnr)
		end

		local function is_big_file(bufnr)
			local max_lint_size = 300 * 1024
			local max_lint_lines = 5000
			local filename = vim.api.nvim_buf_get_name(bufnr)
			local stat = filename ~= "" and vim.uv.fs_stat(filename) or nil

			return vim.b[bufnr].bigfile
				or vim.api.nvim_buf_line_count(bufnr) > max_lint_lines
				or (stat and stat.size > max_lint_size)
		end

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
			group = lint_augroup,
			callback = function(args)
				if vim.bo[args.buf].modifiable and not is_big_file(args.buf) then
					local linters = available_linters(args.buf)
					if #linters > 0 then
						local cwd = lint_cwd(args.buf, linters)
						vim.api.nvim_buf_call(args.buf, function()
							lint.try_lint(linters, { cwd = cwd })
						end)
					end
				end
			end,
		})
	end,
}
