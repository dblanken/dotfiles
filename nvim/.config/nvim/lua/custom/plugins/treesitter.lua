return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			{ dir = "~/plugins/tree-sitter-lua" },
		},
		build = ":TSUpdate",
		config = function()
			local group = vim.api.nvim_create_augroup("custom-treesitter", { clear = true })

			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"vim",
					"vimdoc",
					"query",
					"markdown",
					"markdown_inline",
					"bash",
					"diff",
					"dockerfile",
					"editorconfig",
					"git_config",
					"git_rebase",
					"gitattributes",
					"gitcommit",
					"gitignore",
					"html",
					"javascript",
					"jq",
					"jsdoc",
					"json",
					"json5",
					"luadoc",
					"php",
					"phpdoc",
					"python",
					"readline",
					"regex",
					"ruby",
					"scss",
					"sql",
					"ssh_config",
					"tmux",
					"toml",
					"twig",
					"typescript",
					"xml",
					"yaml",
				},

				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,

				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
				auto_install = true,

				indent = {
					enable = true,
				},

				highlight = {
					-- `false` will disable the whole extension
					enable = true,

					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = { "markdown" },
				},
			})

			local syntax_on = {
				elixir = true,
				php = true,
			}

			vim.api.nvim_create_autocmd("FileType", {
				group = group,
				callback = function(args)
					local bufnr = args.buf
					local ft = vim.bo[bufnr].filetype
					pcall(vim.treesitter.start)

					if syntax_on[ft] then
						vim.bo[bufnr].syntax = "on"
					end
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "TSUpdate",
				callback = function()
					local parsers = require("nvim-treesitter.parsers")

					parsers.lua = {
						tier = 0,

						---@diagnostic disable-next-line: missing-fields
						install_info = {
							path = "~/plugins/tree-sitter-lua",
							files = { "src/parser.c", "src/scanner.c" },
						},
					}
				end,
			})
		end,
	},
}
