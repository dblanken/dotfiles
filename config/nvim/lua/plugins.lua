return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  -- use {
  --   'w0rp/ale',
  --   ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex'},
  --   cmd = 'ALEEnable',
  --   config = 'vim.cmd[[ALEEnable]]'
  -- }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use {'dracula/vim', as = 'dracula'}
  use 'christoomey/vim-tmux-navigator'
  use 'tpope/vim-abolish'
  use 'tpope/vim-apathy'
  use { 
    'tpope/vim-bundler',
    ft = {'ruby'},
    cmd = 'Bundler'
  }
  use 'tpope/vim-characterize'
  use 'tpope/vim-commentary'
  use 'tpope/vim-dadbod'
  use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}
  use 'tpope/vim-dotenv'
  use 'tpope/vim-endwise'
  use 'tpope/vim-eunuch'
  use 'tpope/vim-flagship'
  use { 'tpope/vim-fugitive' }
  use 'tpope/vim-git'
  use 'tpope/vim-jdaddy'
  use 'tpope/vim-markdown'
  use 'tpope/vim-projectionist'
  use 'tpope/vim-ragtag'
  use 'tpope/vim-rails'
  use { 
    'tpope/vim-rake',
    ft = { 'ruby' },
    cmd = 'Rake'
  }
  use 'tpope/vim-repeat'
  use 'tpope/vim-rhubarb'
  use 'tpope/vim-rvm'
  use 'tpope/vim-sleuth'
  use 'tpope/vim-speeddating'
  use 'tpope/vim-surround'
  use 'tpope/vim-tbone'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-vinegar'
  use { 'tpope/vim-vividchalk', opt = true }
  use {
    'vim-pandoc/vim-pandoc',
    ft = { 'markdown', 'pandoc' }
  }
  use 'vim-test/vim-test'
  use 'wincent/loupe'
  use 'wincent/terminus'
  use 'jiangmiao/auto-pairs'
  use 'kana/vim-textobj-user'
  use 'nelstrom/vim-textobj-rubyblock'

  use 'neovim/nvim-lspconfig'
  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
end)

