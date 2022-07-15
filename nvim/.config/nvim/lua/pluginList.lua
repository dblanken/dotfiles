local present, packer = pcall(require, "packerInit")

if present then
  packer = require "packer"
else
  return false
end

local use = packer.use
return packer.startup(function()
  -- Have packer manage itself
  use "wbthomason/packer.nvim"
  use "lewis6991/impatient.nvim"

  use {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require "plugins.treesitter"
    end,
  }

  use {
    "neovim/nvim-lspconfig",
    after = "nvim-lsp-installer",
    config = function()
      require "plugins.lspconfig"
    end,
  }

  use { "williamboman/nvim-lsp-installer", }

  use {
    "rafamadriz/friendly-snippets",
    event = "InsertEnter",
  }

  -- use {
  --   'numToStr/Comment.nvim',
  --   after = "friendly-snippets",
  --   config = function()
  --     require('plugins.others').comment()
  --   end
  -- }

  use {
    "hrsh7th/nvim-cmp",
    after = "friendly-snippets",
    config = function()
      require "plugins.cmp"
    end,
  }

  use {
    "L3MON4D3/LuaSnip",
    wants = "friendly-snippets",
    after = "nvim-cmp",
    config = function()
      require("plugins.others").luasnip()
    end,
  }

  use {
    "saadparwaiz1/cmp_luasnip",
    after = "LuaSnip",
  }

  use {
    "hrsh7th/cmp-nvim-lua",
    after = "nvim-cmp",
  }

  use {
    "hrsh7th/cmp-nvim-lsp",
    after = "nvim-cmp",
  }

  use {
    "lukas-reineke/cmp-rg",
    after = "nvim-cmp",
  }

  use {
    "ray-x/cmp-treesitter",
    after = "nvim-cmp",
  }

  use {
    "hrsh7th/cmp-path",
    after = "nvim-cmp",
  }

  use {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    requires = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        "nvim-lua/plenary.nvim",
        run = "make",
      },
    },
    config = function()
      require "plugins.telescope"
    end,
  }

  use {
    'iamcco/markdown-preview.nvim',
    run = function()
      vim.fn['mkdp#util#install']()
    end,
    ft = { 'markdown', 'vimwiki' }
  }

  use {
    "vim-test/vim-test",
    ft = { 'ruby', 'html', 'eruby', 'rails' },
    config = function()
      require "plugins.vim-test"
    end,
    after = "vim-dispatch"
  }

  use {
    'ecomba/vim-ruby-refactoring',
    tag = 'main',
    ft = { "ruby", "rails" }
  }

  use {
    "tpope/vim-rails",
    ft = { 'ruby', 'eruby', 'rails' }
  }
  use {
    "tpope/vim-bundler",
    ft = { 'ruby', 'eruby', 'rails' },
    after = "vim-rails"
  }
  use {
    "tpope/vim-rake",
    ft = { 'ruby', 'eruby', 'rails' },
    after = "vim-rails"
  }

  use {
    "tpope/vim-dispatch",
    ft = { 'ruby', 'html', 'erb', 'rails' },
  }

  use {
    "tpope/vim-unimpaired",
    event = "VimEnter"
  }

  use {
    "tpope/vim-fugitive",
    event = "VimEnter"
  }

  use {
    "tpope/vim-ragtag",
    ft = { "eruby", "html" }
  }

  use {
    "andrewradev/splitjoin.vim",
    ft = { "ruby", "rails" }
  }

  use {
    'vimwiki/vimwiki',
    event = "VimEnter",
    config = function()
      require('plugins.vimwiki')
    end
  }

  use {
    'vim-pandoc/vim-pandoc',
    ft = { 'vimwiki', 'markdown' }
  }

  use {
    'vim-pandoc/vim-pandoc-syntax',
    ft = { 'vimwiki', 'markdown' }
  }

  use {
    'mattn/emmet-vim',
    ft = { 'html', 'eruby' }
  }

  use {
    'godlygeek/tabular',
    event = "VimEnter"
  }
  use { "tpope/vim-eunuch" }
  use { "tpope/vim-surround" }
  use { "tpope/vim-commentary" }
  use { "tpope/vim-sleuth" }
  use { "tpope/vim-projectionist" }
  use { "tpope/vim-flagship" }
  use { "tpope/vim-abolish" }
  use { "tpope/vim-repeat" }
  use { "christoomey/vim-tmux-navigator" }
  use { 'khuei/base16-nvim' }
  use { 'tribela/vim-transparent' }
  use { 'ludovicchabant/vim-gutentags' }
end)
