return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"folke/neodev.nvim",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			{ "j-hui/fidget.nvim", opts = {} },

			-- Autoformatting
			"stevearc/conform.nvim",

			-- Schema information
			"b0o/SchemaStore.nvim",
		},
		config = function()
			require("neodev").setup({
				-- library = {
				--   plugins = { "nvim-dap-ui" },
				--   types = true,
				-- },
			})

			local capabilities = nil
			if pcall(require, "cmp_nvim_lsp") then
				capabilities = require("cmp_nvim_lsp").default_capabilities()
			end

			local lspconfig = require("lspconfig")

			local servers = {
				bashls = true,
				lua_ls = true,
				cssls = true,
				intelephense = {
					on_init = function(client)
						client.server_capabilities.documentFormattingProvider = false
					end,
					init_options = {
						globalStoragePath = os.getenv("HOME") .. "/.local/share/intelephense",
					},
					config = {
						["intelephense.environment.includePaths"] = {
							"web/core/includes",
						},
						["intelephense.files.associations"] = {
							"*.inc",
							"*.theme",
							"*.install",
							"*.module",
							"*.profile",
							"*.php",
							"*.phtml",
						},
					},
				},

				-- Probably want to disable formatting for this lang server
				tsserver = true,

				jsonls = {
					settings = {
						json = {
							schemas = require("schemastore").json.schemas(),
							validate = { enable = true },
						},
					},
				},

				yamlls = {
					settings = {
						yaml = {
							schemaStore = {
								enable = false,
								url = "",
							},
							schemas = require("schemastore").yaml.schemas(),
						},
					},
				},
			}

			local servers_to_install = vim.tbl_filter(function(key)
				local t = servers[key]
				if type(t) == "table" then
					return not t.manual_install
				else
					return t
				end
			end, vim.tbl_keys(servers))

			require("mason").setup()
			local ensure_installed = {
				"eslint_d",
				"htmlbeautifier",
				"lua_ls",
				"markdownlint",
				"phpcbf",
				"shfmt",
				"sql-formatter",
				"stylelint",
				"stylua",
				"twigcs",
				"twig-cs-fixer",
				"yamlfmt",
				-- "tailwind-language-server",
			}

			vim.list_extend(ensure_installed, servers_to_install)
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			for name, config in pairs(servers) do
				if config == true then
					config = {}
				end
				config = vim.tbl_deep_extend("force", {}, {
					capabilities = capabilities,
				}, config)

				lspconfig[name].setup(config)
			end

			local disable_semantic_tokens = {
				lua = true,
			}

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local bufnr = args.buf
					local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

					vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
					vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = 0 })
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
					vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
					vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })

					vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, { buffer = 0 })
					vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = 0 })

					local filetype = vim.bo[bufnr].filetype
					if disable_semantic_tokens[filetype] then
						client.server_capabilities.semanticTokensProvider = nil
					end
				end,
			})

			-- Autoformatting Setup
			require("conform").setup({
				-- log_level = vim.log.levels.DEBUG,
				formatters = {
					phpcbf = {
						args = function(_, ctx)
							return {
								"--standard=Drupal",
								"--extensions=php,module,inc,install,test,profile,theme,info,txt",
								"$FILENAME",
								-- "-q",
								-- "--stdin-path=" .. ctx.filename,
								-- "-",
							}
						end,
					},
				},
				formatters_by_ft = {
					css = { "stylelint" },
					html = { "htmlbeautifier" },
					javascript = { "eslint_d" },
					json = { "jq" },
					lua = { "stylua" },
					markdown = { "markdownlint" },
					php = { "phpcbf" },
					scss = { "stylelint" },
					sh = { "shfmt" },
					sql = { "sql_formatter" },
					vimwiki = { "markdownlint" },
					yaml = { "yamlfmt" },
				},
			})

			vim.api.nvim_create_autocmd("BufWritePre", {
				callback = function(args)
					require("conform").format({
						bufnr = args.buf,
						lsp_fallback = true,
						quiet = true,
						timeout_ms = 500,
					})
				end,
			})
		end,
	},
}
