vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function()
  use { "wbthomason/packer.nvim", opt = true }

  -- Should be built in
  use {
    'tpope/vim-surround',
    event = "VimEnter"
  }

  -- Commenting
  use {
    'tpope/vim-commentary',
    event = "VimEnter"
  }

  -- Rails development
  use {
    'tpope/vim-rails', 
    event = "VimEnter",
    config = function()
      require('plugins.vim-rails')
    end
  }
  use {
    'tpope/vim-bundler',
    event = "VimEnter"
  }
  use {
    'tpope/vim-rake',
    event = "VimEnter"
  }

  -- Async make
  use {
    'tpope/vim-dispatch',
    cmd = {'Dispatch', 'Make', 'Focus', 'Start'}
  }

  -- Easy testing
  use {
    'vim-test/vim-test',
    after = "vim-dispatch",
    cmd = {'TestNearest', 'TestFile', 'TestSuite', 'TestLast'},
    config = function()
      require('plugins.vim-test')
    end
  }

  -- Tmux integration
  use {
    'christoomey/vim-tmux-navigator',
    event = "VimEnter",
  }

  -- Shell commands
  use {
    'tpope/vim-eunuch',
    event = "VimEnter",
  }

  -- Plugin repeat
  use {
    'tpope/vim-repeat',
    event = "VimEnter",
  }

  -- Easy bracket mappings
  use {
    'tpope/vim-unimpaired',
    event = "VimEnter",
  }

  -- For custom text objects
  use {
    'kana/vim-textobj-user',
    event = "VimEnter",
  }

  -- Ruby block text objects
  use {
    'nelstrom/vim-textobj-rubyblock',
    after = 'vim-textobj-user'
  }

  -- Work-based traversal over Camel/Snake-case
  use {
    'bkad/CamelCaseMotion',
    after = 'vim-textobj-user'
  }

  -- Lsp setup
  use {
    "kabouzeid/nvim-lspinstall",
    event = "BufRead"
  }

  use {
    "neovim/nvim-lspconfig",
    after = "nvim-lspinstall",
    config = function()
      require('plugins.lspconfig')
    end
  }

  use {
    "nvim-lua/plenary.nvim",
    event = "BufRead"
  }
  use {
    "nvim-lua/popup.nvim",
    after = "plenary.nvim"
  }

  -- Fuzzy finding
  use {
    "nvim-telescope/telescope.nvim",
    module = {"telescope.builtin", "plugins.telescope_custom", "telescope"},
    requires = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
      },
      {
        "nvim-telescope/telescope-media-files.nvim",
      }
    },
    config = function()
      require "plugins.telescope"
    end
  }

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    event = "BufRead"
  }

  -- Completion
  use {
    "hrsh7th/nvim-compe",
    event = "InsertEnter",
    config = function()
      require "plugins.compe"
    end,
    wants = "LuaSnip",
    requires = {
      {
        "L3MON4D3/LuaSnip",
        wants = "friendly-snippets",
        event = "InsertCharPre",
        config = function()
          require "plugins.luasnip"
        end
      },
      {
        "rafamadriz/friendly-snippets",
        event = "InsertCharPre"
      }
    },
  }

  -- Complete common pairings in code
  use {
    "windwp/nvim-autopairs",
    after = "nvim-compe",
    config = function()
      require "plugins.autopairs"
    end
  }

  -- Status line configuration
  use {
    "glepnir/galaxyline.nvim",
    after = "gruvbox",
    config = function()
      require "plugins.statusline"
    end
  }

  use {
    'morhetz/gruvbox',
    config = function()
      require "theme"
    end
  }

  use {
    "kyazdani42/nvim-web-devicons",
    after = "gruvbox",
  }

  -- use {
  --   "shaunsingh/nord.nvim",
  --   event = "VimEnter",
  --   config = function()
  --     require "theme"
  --   end
  -- }

  -- Quickly convert to SnakeCase, etc.
  use {
    'tpope/vim-abolish',
    event = {"CursorHold", "CursorHoldI"},
  }

  -- Git integration
  use {
    'tpope/vim-fugitive',
    cmd = {"G", "Gstatus", "Glog", "Gblame", "Gpush", "Gpull"},
  }

  -- Easy tree navigation if I ever need it
  use {
    'tpope/vim-vinegar',
    event = "VimEnter",
  }

  -- dae
  use {
    'kana/vim-textobj-entire',
    after = "vim-textobj-user"
  }

  -- dai
  use {
    'kana/vim-textobj-indent',
    after = "vim-textobj-user"
  }

  -- das
  use {
    'kana/vim-textobj-syntax',
    after = "vim-textobj-user"
  }

  -- dal
  use {
    'kana/vim-textobj-line',
    after = "vim-textobj-user"
  }

  -- Prettier lsp display
  use {
    'glepnir/lspsaga.nvim',
    module = {"lspsaga.diagnostic", "lspsaga.rename", "lspsaga.hover"},
  }

  -- Test start time
  use {
    'tweekmonster/startuptime.vim',
    cmd = "StartupTime"
  }

  use {
    'tribela/vim-transparent',
    after = 'gruvbox'
  }

  use {
    'henriquehbr/nvim-startup.lua',
    config = function()
      require 'nvim-startup'.setup {
        startup_file = '/tmp/nvim-startuptime'
      }
    end
  }
end)
