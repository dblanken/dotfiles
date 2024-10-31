--[[
-- Setup initial configuration,
-- 
-- Primarily just download and execute lazy.nvim
--]]
vim.g.mapleader = " "
vim.g.localmapleader = ","

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

-- Add lazy to the `runtimepath`, this allows us to `require` it.
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Set up lazy, and load my `lua/custom/plugins/` folder
require("lazy").setup({ import = "custom/plugins" }, {
	change_detection = {
		notify = false,
	},
})

vim.g.ruby_host_prog = vim.fn.expand("~/.local/share/mise/shims/neovim-ruby-host")
