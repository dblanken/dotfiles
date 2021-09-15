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

  use 'thoughtbot/vim-rspec'

  use 'christoomey/vim-tmux-navigator'
  use 'vim-ruby/vim-ruby'
  use 'vim-test/vim-test'

  use 'AndrewRadev/splitjoin.vim'
  use 'AndrewRadev/sideways.vim'

  use {
    'JoosepAlviste/nvim-ts-context-commentstring',
    after = 'nvim-treesitter',
    config = function()
      require 'plugins/nvim-ts-context-commentstring'
    end
  }

  use {
    'nvim-telescope/telescope.nvim',
    module = "telescope.builtin",
    cmd = "Telescope",
    requires = {
      {'nvim-lua/plenary.nvim'},
    }
  }

  if CurrentLSP == LSPS["builtin"] then
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
        },
      }
    }

    use {
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'make',
      after = "telescope.nvim",
      config = function()
        require 'plugins.telescope-fzf-native'
      end
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

  end

  if CurrentLSP == LSPS["coc"] then
    use {
      'neoclide/coc.nvim', branch = 'release', config = function()
        require 'plugins.coc'
      end
    }
    use {
      'SirVer/ultisnips'
    }
    use {
      'honza/vim-snippets'
    }

    use {
      'fannheyward/telescope-coc.nvim',
      after = 'telescope.nvim',
      config = function()
        require('telescope').load_extension('coc')
      end
    }
  end

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use {
    'gruvbox-community/gruvbox',
    after = "packer.nvim",
    config = function()
      require 'theme'
    end
  }

  use {
    'bkad/CamelCaseMotion',
    config = function()
      require 'plugins.camelcasemotion'
    end
  }

  use 'godlygeek/tabular'

  use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install'}

  use 'vim-pandoc/vim-pandoc'
  use 'vim-pandoc/vim-pandoc-syntax'
  use {
    'nelstrom/vim-textobj-rubyblock',
    requires = { { 'kana/vim-textobj-user'} },
    ft = "ruby"
  }

  use {
    'wincent/corpus',
    setup = function()
      require 'plugins.corpus'
    end
  }

  use {
    'ojroques/nvim-hardline',
    config = function()
      require('hardline').setup {
        theme = 'gruvbox'
      }
    end
  }

  use {
    "fatih/vim-go",
    run = ":GoUpdateBinaries"
  }
end
)
