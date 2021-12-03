vim.cmd [[packadd packer.nvim]]

return require("packer").startup({
  function(use)
    use "wbthomason/packer.nvim"

    use "neovim/nvim-lspconfig"
    use "vim-ruby/vim-ruby"
    use "tpope/vim-rails"
    use "tpope/vim-surround"
    use "vim-test/vim-test"
    -- use "tpope/vim-commentary"
    use {
      "numToStr/Comment.nvim",
      config = function()
        require('Comment').setup({
          toggler = {
            line = 'gcl',
            block = 'gbl'
          }
        })
      end
    }
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
    use { "tpope/vim-dispatch", cmd = { "Dispatch", "Make" } }
    use {
      'nvim-telescope/telescope.nvim',
      requires = { {'nvim-lua/plenary.nvim'} }
    }
    -- use { 'dracula/vim', as = 'dracula' }
    use { 'Mofiqul/dracula.nvim'}
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
    use {
      "nvim-lualine/lualine.nvim",
      requires = {
        "kyazdani42/nvim-web-devicons", opt = true
      },
      config = function()
        require('lualine').setup {
          options = {
            theme = 'dracula-nvim'
          }
        }
      end
    }
    use 'lewis6991/impatient.nvim'
  end,
  config = {
    compile_path = vim.fn.stdpath('config')..'/lua/packer_compiled.lua'
  }
})
