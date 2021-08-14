return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'tpope/vim-bundler'
  use 'tpope/vim-commentary'
  use 'tpope/vim-dispatch'
  use 'tpope/vim-endwise'
  use 'tpope/vim-eunuch'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-git'
  use 'tpope/vim-jdaddy'
  use 'tpope/vim-markdown'
  use 'tpope/vim-projectionist'
  use 'tpope/vim-ragtag'
  use 'tpope/vim-rails'
  use 'tpope/vim-rake'
  use 'tpope/vim-repeat'
  use 'tpope/vim-rhubarb'
  use 'tpope/vim-sleuth'
  use 'tpope/vim-surround'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-vinegar'
  use 'tpope/vim-vividchalk'

  use 'christoomey/vim-tmux-navigator'
  use 'bkad/CamelCaseMotion'

  use {
    'vim-test/vim-test',
    config = function()
      require('vim-test')
    end
  }

  use {
    'neovim/nvim-lspconfig',
    requires = { { 'kabouzeid/nvim-lspinstall' }, { 'glepnir/lspsaga.nvim' } },
    config = function()
      require('lsp')
    end
  }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use { 
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } },
    config = function()
      require('dblanken.telescope')
    end
  }

  use {
  'glepnir/galaxyline.nvim',
    branch = 'main',
    config = function() require'statusline' end,
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }

  use {
    "hrsh7th/nvim-compe",
    config = function()
      require "plugins.compe"
    end,
    wants = "LuaSnip",
    requires = {
      {
        "L3MON4D3/LuaSnip",
        wants = "friendly-snippets",
        config = function()
          require "plugins.luasnip"
        end
      },
      {
        "rafamadriz/friendly-snippets",
      }
    },
  }

  use {
    "windwp/nvim-autopairs",
    after = "nvim-compe",
    config = function()
      require "plugins.autopairs"
    end
  }

  use {
    'nelstrom/vim-textobj-rubyblock',
    requires = { { 'kana/vim-textobj-user' } },
    ft = 'ruby'
  }

  use {
    'ecomba/vim-ruby-refactoring',
    ft = 'ruby'
  }

  use {
    "npxbr/gruvbox.nvim",
    requires = {"rktjmp/lush.nvim"},
    config = function()
      require 'colorscheme'
    end
  }

  use {"npxbr/glow.nvim", run = "GlowInstall"}
end)
