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
					-- require("formatter.filetypes.php").phpcbf,
					function()
						local rootPath = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

						if rootPath == nil then
							rootPath = masonPath
						elseif vim.fn.filereadable(rootPath .. "/vendor/bin/phpcbf") == 1 then
							rootPath = rootPath .. "/vendor/bin"
						else
							rootPath = masonPath
						end

						return {
							exe = rootPath .. "/phpcbf",
							args = {
								"--standard=Drupal",
								"--extensions=php,module,inc,install,test,profile,theme,info,txt",
								"-",
							},
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
					require("formatter.filetypes.any").remove_trailing_whitespace,
				},
			},
		})

		local filetypes = {}
		for key, _ in pairs(require("formatter.config").values.filetype) do
			if key ~= "*" then
				table.insert(filetypes, key)
			end
		end

		vim.api.nvim_create_augroup("formatterNvim", {
			clear = true
		})

		vim.api.nvim_create_autocmd("Filetype", {
			group = 'formatterNvim',
			pattern = table.concat(filetypes, ","),
			callback = function()
				vim.keymap.set({ "n", "v" }, "<leader>=", "<cmd>Format<CR>", { buffer = true })
				vim.keymap.set({ "n", "v" }, "<leader>f", "<cmd>Format<CR>", { buffer = true })
			end,
		})
	end,
}
