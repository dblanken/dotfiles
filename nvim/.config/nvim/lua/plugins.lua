vim.cmd [[ packadd packer.nvim ]]
local use = require('packer').use
local is_rails = function()
  return vim.fn.filereadable('Gemfile') > 0 or vim.fn.filereadable('config.ru') > 0
end

return require('packer').startup(function()
  use {
    'wbthomason/packer.nvim',
    cmd = {
      'PackerSync',
      'PackerClean',
      'PackerInstall',
      'PackerUpdate',
      'PackerStatus',
      'PackerCompile',
      'PackerLoad',
    },
    module = 'packer.nvim',
    config = function()
      require('plugins')
    end
  }

  use {
    'tpope/vim-bundler',
    cond = is_rails,
  }

  use 'tpope/vim-commentary'

  use {
    'tpope/vim-dispatch',
    cmd = {
      'Dispatch',
      'Make',
      'Focus',
      'Start',
    },
  }

  use {
    'tpope/vim-endwise',
    ft = {
      'lua',
      'elixir',
      'ruby',
      'crystal',
      'sh',
      'zsh',
      'vb',
      'vbnet',
      'aspvbs',
      'vim',
      'c',
      'cpp',
      'xdefaults',
      'haskell',
      'objc',
      'make',
      'verilog',
      'matlab',
      'htmldjango',
      'htmljinja',
      'jinja.html',
      'snippets',
    }
  }

  use {
    'tpope/vim-eunuch',
    cmd = {'Delete', 'Rename'},
  }
  use {
    'tpope/vim-fugitive',
    cmd = {'G', 'Gstatus', 'Glog', 'Gcommit', 'Gdiff', 'Gbrowse'}
  }
  use {
    'tpope/vim-git',
    ft = {"git", "gitcommit"},
  }
  use {
    'tpope/vim-jdaddy',
    ft = "json",
  }
  use {
    'tpope/vim-markdown',
    ft = "markdown"
  }

  use {
    'tpope/vim-projectionist',
    cond = function()
      return vim.fn.filereadable('./.projections.json') > 0
    end,
  }

  use {
    'tpope/vim-ragtag',
    ft = {"eruby", "html", "mason"},
  }

  use {
    'tpope/vim-rails',
    cond = is_rails,
  }

  use {
    'tpope/vim-rake',
    cond = is_rails
  }
  use 'tpope/vim-repeat'
  use {
    'tpope/vim-rhubarb',
    cmd = "Gbrowse",
    setup = function()
      vim.g.github_enterprise_urls = {'https://github.iu.edu'}
    end
  }
  use 'tpope/vim-sleuth'
  use {
    'tpope/vim-surround',
    keys = {
      {'n', 'ds'},
      {'n', 'cs'},
      {'n', 'cS'},
      {'n', 'ys'},
      {'n', 'yS'},
      {'n', 'yss'},
      {'n', 'ySs'},
      {'n', 'ySS'},
      {'x', 'S'},
      {'x', 'gS'},
      {'i', '<C-S>'},
      {'i', '<C-G>s'},
      {'i', '<C-G>S'},
    },
  }
  use {
    'tpope/vim-unimpaired',
    opt = true,
    keys = {
      {"", "[q"},
      {"", "]q"},
      {"", "]f"},
      {"", "[f"},
    },
  }
  use {
    'tpope/vim-vinegar',
    keys = {
      {"", "-"},
    },
  }

  use {
    'christoomey/vim-tmux-navigator',
    keys = {
      {"", "<C-h>"},
      {"", "<C-j>"},
      {"", "<C-k>"},
      {"", "<C-l>"},
    }
  }

  use {
    'bkad/CamelCaseMotion',
    opt = true,
    keys = {
      {"", "<Leader>w"},
    },
    setup = function()
      vim.g.camelcasemotion_key = '<leader>'
    end
  }

  use {
    'vim-test/vim-test',
    cmd = { "TestFile", "TestNearest", "TestSuite", "TestLast" },
    keys = {
      {"", "<Leader>t"},
      {"", "<Leader>T"},
      {"", "<Leader>a"},
      {"", "<Leader>l"},
    },
    config = function()
      require('vim-test')
    end
  }

  use {
    'neovim/nvim-lspconfig',
    requires = { { 'kabouzeid/nvim-lspinstall' }, { 'glepnir/lspsaga.nvim', module = "lspsaga" } },
    config = function()
      require('lsp')
    end
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    event = {'CursorHold', 'CursorHoldI'},
    run = ':TSUpdate'
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim', module = "plenary" } },
    module = "telescope",
    keys = {
      {"", "<C-p>"},
      {"", "<Leader>ff"},
      {"", "<Leader>fg"},
      {"", "<Leader>en"},
    },
    config = function()
      require('dblanken.telescope')
    end
  }

  use {
  'glepnir/galaxyline.nvim',
    branch = 'main',
    config = function() require'statusline' end,
    requires = {'kyazdani42/nvim-web-devicons', module = "nvim-web-devicons"}
  }

  use {
    "hrsh7th/nvim-compe",
    event = {'InsertEnter'},
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
    event = "VimEnter",
    config = function()
      require 'colorscheme'
    end
  }

  use {
    'AndrewRadev/splitjoin.vim',
    keys = {
      {"n", "gS"},
      {"n", "gJ"},
    },
  }

  use {
    'tweekmonster/startuptime.vim',
    cmd = "StartupTime"
  }

  use {
    'wincent/corpus'
  }

  use {
    "npxbr/glow.nvim",
    ft = "markdown",
    run = "GlowInstall"
  }

  use {
    'sotte/presenting.vim',
    cmd = "StartPresenting"
  }

  use {
    'kchmck/vim-coffee-script',
    ft = 'coffee'
  }

end)
