local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  -- Utilities
  use "wbthomason/packer.nvim"

  -- Plugins

  -- LUA
  use {
    "nvim-telescope/telescope.nvim",
    requires = { { "nvim-lua/plenary.nvim"} }
  }
  use "nvim-treesitter/nvim-treesitter"
  use "RRethy/nvim-treesitter-endwise"
  use "Mephistophiles/surround.nvim"
  use "neovim/nvim-lspconfig"
  use {
    "SmiteshP/nvim-gps",
    requires = "nvim-treesitter/nvim-treesitter"
  }
  -- use "williamboman/nvim-lsp-installer"
  -- Completion
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-cmdline"
  use "L3MON4D3/LuaSnip"
  use "saadparwaiz1/cmp_luasnip"
  use "rafamadriz/friendly-snippets"
  use "kyazdani42/nvim-web-devicons"
  use "nvim-lualine/lualine.nvim"
  use "lewis6991/gitsigns.nvim"
  use "lewis6991/impatient.nvim"
  use "iamcco/markdown-preview.nvim"
  -- Colorschemes
  use "folke/tokyonight.nvim"

  -- Non LUA
  use "christoomey/vim-tmux-navigator"
  use "dblanken/vim-unimpaired"
  use "rhysd/conflict-marker.vim"
  use "tpope/vim-bundler"
  use "tpope/vim-commentary"
  use "tpope/vim-dispatch"
  use "tpope/vim-eunuch"
  use "tpope/vim-fugitive"
  use "tpope/vim-projectionist"
  use "tpope/vim-ragtag"
  use "tpope/vim-rails"
  use "tpope/vim-rake"
  use "tpope/vim-repeat"
  use "tpope/vim-rhubarb"
  use "tpope/vim-vinegar"
  use "vim-pandoc/vim-pandoc"
  use "vim-pandoc/vim-pandoc-syntax"
  use "vim-test/vim-test"
  use "vimwiki/vimwiki"

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
