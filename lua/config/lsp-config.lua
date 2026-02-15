local somesass_ls = {
	filetypes = { "scss", "sass", "css", "vue", "tsx", "jsx" },
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

local prettierd_config = {
	filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" },
}

local yamlls_config = {
	settings = {
		yaml = {
			schemas = {
				kubernetes = { "k8s/**/*.yaml", "k8s/**/*.yml" },
				["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.{yml,yaml}",
				["https://json.schemastore.org/github-action.json"] = ".github/action.{yml,yaml}",
				["https://json.schemastore.org/docker-compose.json"] = "docker-compose*.{yml,yaml}",
				["https://json.schemastore.org/chart.json"] = "Chart.yaml",
				["https://json.schemastore.org/kustomization.json"] = "kustomization.yaml",
			},
			validate = true,
			completion = true,
			hover = true,
		},
	},
}

local ruff_config = {
	-- Disable hover in favor of basedpyright (avoid duplicate hover info)
	on_attach = function(client, _)
		client.server_capabilities.hoverProvider = false
	end,
}

vim.lsp.config("somesass_ls", somesass_ls)
vim.lsp.config("css_variables", css_variables)
vim.lsp.config("prettierd", prettierd_config)
vim.lsp.config("yamlls", yamlls_config)
vim.lsp.config("ruff", ruff_config)
