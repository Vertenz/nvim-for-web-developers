local somesass_ls = {
	filetypes = { "scss", "sass", "vue" },
	settings = {
		somesass = {
			loadPaths = { "app/assets/scss" },
			suggestFromUseOnly = false,
			scanImportedFiles = true,
		},
	},
}

local css_variables = {
	filetypes = { "css", "scss", "sass", "less", "vue" },
	init_options = {
		cssVariables = {
			enabled = true,
			workspaceFolder = vim.fn.getcwd(),
		},
	},
}

local stylelint_lsp_config = {
	settings = {
		stylelint = {
			validate = { "css", "postcss", "scss", "less", "vue" },
		},
	},
}

local lua_ls_config = {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				checkThirdParty = false,
			},
		},
	},
}

local jsonls_config = {
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
}

local yamlls_config = {
	settings = {
		yaml = {
			schemaStore = { enable = false, url = "" },
			schemas = require("schemastore").yaml.schemas({
				extra = {
					{
						description = "Kubernetes resource definitions",
						fileMatch = { "k8s/**/*.yaml", "k8s/**/*.yml" },
						name = "kubernetes",
						url = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.36.0-standalone-strict/all.json",
					},
				},
			}),
			validate = true,
			completion = true,
			hover = true,
		},
	},
}

local postgres_lsp_config = {
	filetypes = { "sql" },
	root_markers = { "postgres-language-server.jsonc", ".sqllsrc.json", "package.json", ".git" },
	workspace_required = false,
}

local sqlls_config = {
	root_markers = { ".sqllsrc.json" },
}

local ruff_config = {
	-- Disable hover in favor of basedpyright (avoid duplicate hover info)
	on_attach = function(client, _)
		client.server_capabilities.hoverProvider = false
	end,
}

vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

vim.lsp.config("somesass_ls", somesass_ls)
vim.lsp.config("css_variables", css_variables)
vim.lsp.config("stylelint_lsp", stylelint_lsp_config)
vim.lsp.config("lua_ls", lua_ls_config)
vim.lsp.config("jsonls", jsonls_config)
vim.lsp.config("yamlls", yamlls_config)
vim.lsp.config("postgres_lsp", postgres_lsp_config)
vim.lsp.config("sqlls", sqlls_config)
vim.lsp.config("ruff", ruff_config)

vim.lsp.enable({
	"somesass_ls",
	"css_variables",
	"cssls",
	"stylelint_lsp",
	"html",
	"emmet_language_server",
	"tailwindcss",
	"jsonls",
	"yamlls",
	"lua_ls",
	"basedpyright",
	"ruff",
	"marksman",
	"dockerls",
	"docker_compose_language_service",
	"helm_ls",
	"terraformls",
	"tflint",
	"postgres_lsp",
	"sqlls",
})
