local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local packer_bootstrap = false
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'L3MON4D3/LuaSnip'
  use 'MaxMEllon/vim-jsx-pretty'
  use 'andrewradev/splitjoin.vim'
  use 'chriskempson/base16-vim'
  use 'christoomey/vim-tmux-navigator'
  use 'glts/vim-textobj-comment'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-calc'
  use 'hrsh7th/cmp-emoji'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/nvim-cmp'
  use 'kana/vim-textobj-user'
  use 'ludovicchabant/vim-gutentags'
  use 'lukas-reineke/indent-blankline.nvim'
  use 'nelstrom/vim-textobj-rubyblock'
  use 'neovim/nvim-lspconfig'
  use 'nvim-treesitter/nvim-treesitter-context'
  use 'rafamadriz/friendly-snippets'
  use 'saadparwaiz1/cmp_luasnip'
  use 'thoughtbot/vim-rspec'
  use 'tpope/vim-abolish'
  use 'tpope/vim-bundler'
  use 'tpope/vim-commentary'
  use 'tpope/vim-dadbod'
  use 'tpope/vim-dispatch'
  use 'tpope/vim-endwise'
  use 'tpope/vim-eunuch'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-git'
  use 'tpope/vim-markdown'
  use 'tpope/vim-projectionist'
  use 'tpope/vim-ragtag'
  use 'tpope/vim-rails'
  use 'tpope/vim-rake'
  use 'tpope/vim-repeat'
  use 'tpope/vim-rhubarb'
  use 'tpope/vim-scriptease'
  use 'tpope/vim-sleuth'
  use 'tpope/vim-speeddating'
  use 'tpope/vim-surround'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-vinegar'
  use 'tribela/vim-transparent'
  use 'vim-pandoc/vim-pandoc'
  use 'vim-ruby/vim-ruby'
  use 'vim-test/vim-test'
  use 'vimwiki/vimwiki'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install'}
  use { "williamboman/mason.nvim" }
  use { "williamboman/mason-lspconfig.nvim" }
  use { "jose-elias-alvarez/null-ls.nvim" }
  use { "wincent/loupe" }
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
