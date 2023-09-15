return {
	"mhartington/formatter.nvim",
	config = function()
		local util = require("formatter.util")
		local masonPath = vim.fn.stdpath("data") .. "/mason/bin"

		vim.keymap.set({ "n", "v" }, "<leader>f", "<cmd>Format<CR>", { buffer = true })
		vim.keymap.set({ "n", "v" }, "<leader>=", "<cmd>Format<CR>", { buffer = true })

		require("formatter").setup({
			filetype = {
				-- Formatter configurations for filetype "lua" go here
				-- and will be executed in order
				lua = {
					-- "formatter.filetypes.lua" defines default configurations for the
					-- "lua" filetype
					require("formatter.filetypes.lua").stylua,

					-- You can also define your own configuration
					function()
						-- Full specification of configurations is down below and in Vim help
						-- files
						return {
							exe = masonPath .. "/stylua",
							args = {
								"--search-parent-directories",
								"--stdin-filepath",
								util.escape_path(util.get_current_buffer_file_path()),
								"--",
								"-",
							},
							stdin = true,
						}
					end,
				},

				php = {
					require("formatter.filetypes.php").phpcbf,
					function()
						return {
							exe = masonPath .. "/phpcbf",
							stdin = true,
							ignore_exitcode = true,
						}
					end,
				},

				css = {
					require("formatter.filetypes.css").prettierd,
				},

				html = {
					require("formatter.filetypes.html").htmlbeautify,
				},

				javascript = {
					require("formatter.filetypes.javascript").prettierd,
				},

				markdown = {
					require("formatter.filetypes.markdown").prettierd,
				},

				scss = {
					require("formatter.filetypes.css").prettierd,
				},

				sh = {
					require("formatter.filetypes.sh").shfmt,
				},

				typescript = {
					require("formatter.filetypes.typescript").prettierd,
				},

				yaml = {
					require("formatter.filetypes.yaml").prettierd,
				},

				-- Use the special "*" filetype for defining formatter configurations on
				-- any filetype
				["*"] = {
					-- "formatter.filetypes.any" defines default configurations for any
					-- filetype
					require("formatter.filetypes.any").remove_trailing_whitespace,
					function()
						-- If there is an LSP present, use it to format
						-- if vim.lsp.buf_get_clients() ~= nil then
						-- 	return nil
						-- end

						-- If no lsp is loaded, run the formatprg defined for the current
						if vim.bo.formatprg ~= "" then
							return {
								exe = vim.bo.formatprg,
								stdin = true,
							}
						end

						vim.lsp.buf.formatting()
					end
				},
			},
		})
	end,
}
