return {
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.ai").setup()
			require("mini.surround").setup({
				mappings = {
					add = "ys",
					replace = "cs",
				},
			})
		end,
	},
}
