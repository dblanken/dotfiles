vim.cmd [[packadd packer.nvim]]

return require("packer").startup({
  function(use)
    use "wbthomason/packer.nvim"

    use "neovim/nvim-lspconfig"
    use "vim-ruby/vim-ruby"
    use "tpope/vim-rails"
    use "tpope/vim-surround"
    use "vim-test/vim-test"
    use "numToStr/Comment.nvim"
    use "tpope/vim-fugitive"
    use "tpope/vim-eunuch"
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ':TSUpdate',
      require = {
        { "nvim-treesitter/nvim-treesitter-textobjects" },
        { "JoosepAlviste/nvim-ts-context-commentstring" }
      }
    }
    use "nvim-treesitter/playground"
    use { "tpope/vim-dispatch", cmd = { "Dispatch", "Make" } }
    use {
      'nvim-telescope/telescope.nvim',
      requires = { {'nvim-lua/plenary.nvim'} }
    }
    use { 'dracula/vim', as = 'dracula' }
    -- use { 'Mofiqul/dracula.nvim'}
    use "alexghergh/nvim-tmux-navigation"
    use "xiyaowong/nvim-transparent"
    use "windwp/nvim-autopairs"
    use {
      "vim-pandoc/vim-pandoc",
      requires = { { "vim-pandoc/vim-pandoc-syntax" } }
    }
    use {
      "iamcco/markdown-preview.nvim",
      run = function() vim.fn['mkdp#util#install']() end,
      ft = {'markdown'}
    }
    use "plasticboy/vim-markdown"
    use "vimwiki/vimwiki"
    use "michal-h21/vimwiki-sync"
    use "gruvbox-community/gruvbox"
    use {
      "nvim-lualine/lualine.nvim",
      requires = {
        "kyazdani42/nvim-web-devicons", opt = true
      },
      config = function()
        require('lualine').setup {
          options = {
            theme = 'dracula'
          }
        }
      end
    }
    use 'lewis6991/impatient.nvim'
    use {
      "dstein64/vim-startuptime",
      cmd = "StartupTime",
    }
    use {
      "tpope/vim-scriptease",
      cmd = {
        "Messages", --view messages in quickfix list
        "Verbose", -- view verbose output in preview window.
        "Time", -- measure how long it takes to run some stuff.
      },
    }
    use "godlygeek/tabular"
    use "tpope/vim-repeat"
    use {
      "AndrewRadev/splitjoin.vim",
      keys = { "gJ", "gS" },
    }
    if vim.fn.executable "gh" == 1 then
      use "pwntester/octo.nvim"
    end
    use {
      "rhysd/git-messenger.vim",
      keys = "<Plug>(git-messenger)",
    }
    use "lewis6991/gitsigns.nvim"
    use {
      "alec-gibson/nvim-tetris",
      cmd = "Tetris",
    }
    use {
      "antoinemadec/FixCursorHold.nvim"
    }
  end,
  config = {
    compile_path = vim.fn.stdpath('config')..'/lua/packer_compiled.lua',
    display = {}
  }
})
