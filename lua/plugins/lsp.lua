local servers = {
	"vtsls",
	"vue_ls",
	"lua_ls",
	"html",
	"emmet_language_server",
	"tailwindcss",
	"stylelint_lsp",
	"somesass_ls",
	"css_variables",
	"cssls",
	"basedpyright",
	"ruff",
	"marksman",
	"dockerls",
	"docker_compose_language_service",
	"yamlls",
	"jsonls",
	"helm_ls",
	"terraformls",
	"tflint",
	"postgres_lsp",
	"sqlls",
	"gopls",
}

local additional = {
	"stylua",
	"stylelint",
	"stylelint-language-server",
	"terraform",
	"sql-formatter",
	"sqlfluff",
	"tree-sitter-cli",
	"gofumpt",
	"goimports",
	"golangci-lint",
	"delve",
	"gotestsum",
}

return {
	{
		"mason-org/mason.nvim",
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "Mason", "MasonInstall", "MasonLog", "MasonUninstall", "MasonUninstallAll", "MasonUpdate" },
		opts = {
			providers = {
				"mason.providers.client",
			},
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		cmd = {
			"MasonToolsInstall",
			"MasonToolsInstallSync",
			"MasonToolsUpdate",
			"MasonToolsUpdateSync",
			"MasonToolsClean",
		},
		dependencies = {
			"mason-org/mason.nvim",
		},
		opts = {
			ensure_installed = additional,
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason-org/mason.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = servers,
			automatic_enable = false,
		},
		config = function(_, opts)
			require("config.vue3-lsp")
			require("config.lsp-config")
			require("mason-lspconfig").setup(opts)
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"b0o/SchemaStore.nvim",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
					map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
					map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
					then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({
									group = "kickstart-lsp-highlight",
									buffer = event2.buf,
								})
							end,
						})
					end

					if
						client
						and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
				},
			})
		end,
	},
}
