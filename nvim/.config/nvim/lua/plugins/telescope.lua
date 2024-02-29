return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
		},
	},
	cmd = {
		"Telescope",
	},
	keys = {
		{
			"<leader>?",
			function()
				require("telescope.builtin").oldfiles()
			end,
			desc = "[?] Find recently opened files",
		},
		{
			"<leader><space>",
			function()
				require("telescope.builtin").buffers()
			end,
			desc = "[ ] Find existing buffers",
		},
		{
			"<Leader>/",
			function()
				-- You can pass additional configuration to telescope to change theme, layout, etc.
				require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end,
			desc = "[/] Fuzzily search in the current buffer",
		},
		{
			"<Leader>sf",
			function()
				require("telescope.builtin").find_files({ hidden = true })
			end,
			desc = "[S]earch [F]iles",
		},
		{
			"<Leader>sh",
			function()
				require("telescope.builtin").help_tags()
			end,
			desc = "[S]earch [H]elp",
		},
		{
			"<leader>sw",
			function()
				require("telescope.builtin").grep_string()
			end,
			desc = "[S]earch current [W]ord",
		},
		{
			"<leader>sg",
			function()
				require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
			end,
			desc = "[S]earch by [G]rep",
		},
		{
			"<leader>sd",
			function()
				require("telescope.builtin").diagnostics()
			end,
			desc = "[S]earch [D]iagnostics",
		},
		{
			"<Leader>sp",
			function()
				require("telescope.builtin").git_files({ hidden = true })
			end,
			desc = "[S]earch Git [P]roject",
		},
		{
			"<Leader>sl",
			function()
				require("telescope.builtin").live_grep()
			end,
			desc = "[S]earch by [L]ive Grep",
		},
	},
	config = function(opts)
		require("telescope").setup {
			extensions = {
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				},
			},
		}
		require("telescope").load_extension("fzf")
	end,
}
