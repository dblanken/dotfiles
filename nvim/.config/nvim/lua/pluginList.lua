local present, _ = pcall(require, 'packerInit')
local packer

if present then
  packer = require 'packer'
else
  return false
end

local use = packer.use

return packer.startup(
function()
  use {
    "wbthomason/packer.nvim",
    event = "VimEnter"
  }

  use 'tpope/vim-bundler'
  use 'tpope/vim-commentary'
  use 'tpope/vim-dispatch'
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
  use 'tpope/vim-surround'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-vinegar'

  use 'christoomey/vim-tmux-navigator'
  use 'vim-ruby/vim-ruby'
  use 'vim-test/vim-test'

  use 'AndrewRadev/splitjoin.vim'
  use 'AndrewRadev/sideways.vim'

  use {
    'kabouzeid/nvim-lspinstall',
    event = "VimEnter"
  }

  use {
    'neovim/nvim-lspconfig',
    after = "nvim-lspinstall",
    config = function()
      require 'plugins.lspconfig'
    end,
    requires = {
      {
        'glepnir/lspsaga.nvim',
        event = "BufRead",
      }
    }
  }

  use {
    'nvim-telescope/telescope.nvim',
    module = "telescope.builtin",
    requires = {
      {'nvim-lua/plenary.nvim'}
    }
  }

  use {
    'hrsh7th/nvim-compe',
    event = "InsertEnter",
    config = function()
      require 'plugins.compe'
    end,
    wants = "vim-vsnip",
    requires = {
      {
        'hrsh7th/vim-vsnip',
        wants = "friendly-snippets",
        event = "InsertCharPre",
      },
      {
        'rafamadriz/friendly-snippets',
        event = "InsertCharPre",
      },
      {
        'onsails/lspkind-nvim',
        event = "BufRead",
        config = function()
          require('plugins.lspkind')
        end
      },
    }
  }

  use {
    'windwp/nvim-autopairs',
    after = "nvim-compe",
    config = function()
      require 'plugins.autopairs'
    end
  }

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use 'AndrewRadev/splitjoin.vim'
  use 'AndrewRadev/sideways.vim'

  use {
    'gruvbox-community/gruvbox',
    after = "packer.nvim",
    config = function()
      require 'theme'
    end
  }
end
)
