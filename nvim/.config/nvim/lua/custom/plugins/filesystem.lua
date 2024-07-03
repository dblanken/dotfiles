return {
	"tpope/vim-eunuch",
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				columns = { "icon" },
				keymaps = {
					["<C-h>"] = false,
					["<M-h>"] = "actions.select_split",
				},
				view_options = {
					show_hidden = true,
				},
			})

			-- Open parent directory in current window
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

			-- Open parent directory in floating window
			vim.keymap.set("n", "<space>-", require("oil").toggle_float)
		end,
	},
	{
		"tpope/vim-projectionist",
		config = function()
			vim.g.projectionist_heuristics = {
				["&pantheon.yml"] = {
					["*"] = { ["dispatch"] = "lando drush cr" },
					["web/core/modules/*.php"] = {
						["type"] = "core",
					},
					["web/profiles/custom/yalesites_profile/modules/*.php"] = {
						["type"] = "profile",
					},
				},
				["&atomic.info.yml"] = {
					["*"] = { ["dispatch"] = "lando drush cr" },
					["templates/*.html.twig"] = {
						["type"] = "template",
					},
				},
				["webpack/webpack.common.js"] = {
					["*"] = { ["dispatch"] = "npm run build" },
					["components/*.twig"] = {
						["type"] = "components",
					},
					["components/*.scss"] = {
						["type"] = "scss",
					},
					["components/*.js"] = {
						["type"] = "js",
					},
					["components/*.yml"] = {
						["type"] = "yml",
					},
				},
			}
		end,
	},
	"tpope/vim-rhubarb",
	"nvim-lua/plenary.nvim",
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			{ "nvim-telescope/telescope-smart-history.nvim" },
			{ "kkharji/sqlite.lua" },
		},
		config = function()
			local data = assert(vim.fn.stdpath("data")) --[[@as string]]

			require("telescope").setup({
				extensions = {
					fzf = {},
					wrap_results = true,
					history = {
						path = vim.fs.joinpath(data, "telescope_history.sqlite3"),
						limit = 100,
					},
				},
			})

			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "smart_history")

			local builtin = require("telescope.builtin")

			vim.keymap.set("n", "<space>fd", builtin.find_files)
			vim.keymap.set("n", "<space>fh", builtin.help_tags)
			vim.keymap.set("n", "<space>fg", builtin.live_grep)
			vim.keymap.set("n", "<space>/", builtin.current_buffer_fuzzy_find)

			vim.keymap.set("n", "<space>gw", builtin.grep_string)

			vim.keymap.set("n", "<space>fa", function()
				---@diagnostic disable-next-line: param-type-mismatch
				builtin.find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
			end)

			vim.keymap.set("n", "<space>en", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end)
		end,
	},
	"tpope/vim-unimpaired",
}
