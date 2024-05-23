return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			local colorscheme = "base16-" .. vim.env["BASE16_THEME"]
			vim.cmd.colorscheme(colorscheme)
		end,
	},
	{ "folke/tokyonight.nvim" },
}
