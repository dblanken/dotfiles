--[[
-- Neovim Configuration
-- A custom config built with lazy.nvim, incorporating best practices from LazyVim
--]]

-- Set leader keys before anything else
vim.g.mapleader = " "
vim.g.localmapleader = ","

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Load configuration
require("custom.config.options")
require("custom.config.keymaps")
require("custom.config.autocmds")

-- Set up lazy.nvim and load plugins
require("lazy").setup({ import = "custom/plugins" }, {
	change_detection = {
		notify = false,
	},
	performance = {
		rtp = {
			-- Disable some rtp plugins for better performance
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
