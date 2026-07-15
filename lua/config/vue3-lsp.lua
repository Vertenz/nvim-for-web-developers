local mason_packages_path = vim.fn.stdpath("data") .. "/mason/packages"
local vue_language_server_path = mason_packages_path .. "/vue-language-server/node_modules/@vue/language-server"
local vtsls_tsdk = mason_packages_path .. "/vtsls/node_modules/@vtsls/language-server/node_modules/typescript/lib"

local vue_plugin = {
	name = "@vue/typescript-plugin",
	location = vue_language_server_path,
	languages = { "vue" },
	configNamespace = "typescript",
}

vim.lsp.config("vtsls", {
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
	settings = {
		vtsls = {
			-- NOTE: do not enable vtsls.autoUseWorkspaceTsdk here — switching to the
			-- workspace TypeScript breaks loading of the mason-installed
			-- @vue/typescript-plugin, and tsserver then parses .vue files as raw TS
			-- ("Cannot find name 'script'" everywhere).
			experimental = {
				completion = {
					enableServerSideFuzzyMatch = true,
					entriesLimit = 1500,
				},
			},
			tsserver = {
				globalPlugins = {
					vue_plugin,
				},
			},
		},
		typescript = {
			inlayHints = {
				enumMemberValues = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				parameterNames = { enabled = "literals" },
				parameterTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				variableTypes = { enabled = false },
			},
			preferences = {
				includePackageJsonAutoImports = "auto",
				preferTypeOnlyAutoImports = true,
			},
			suggest = {
				completeFunctionCalls = true,
			},
		},
		javascript = {
			inlayHints = {
				functionLikeReturnTypes = { enabled = true },
				parameterNames = { enabled = "literals" },
				variableTypes = { enabled = false },
			},
			preferences = {
				includePackageJsonAutoImports = "auto",
			},
			suggest = {
				completeFunctionCalls = true,
			},
		},
	},
})

-- vue-language-server 3.3.x expects the classic TypeScript server API. Mason
-- may install TypeScript 7 next to it, which does not expose ts.server and
-- makes vue_ls crash. Reuse vtsls' compatible TypeScript SDK instead.
vim.lsp.config("vue_ls", {
	cmd = { "vue-language-server", "--stdio", "--tsdk=" .. vtsls_tsdk },
})

vim.lsp.enable({ "vtsls", "vue_ls" })
