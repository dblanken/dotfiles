vim.cmd [[packadd packer.nvim]]

return require("packer").startup {
  function(use)
    use "wbthomason/packer.nvim"

    use "neovim/nvim-lspconfig"
    use "vim-ruby/vim-ruby"
    use "tpope/vim-rails"
    use "tpope/vim-surround"
    use "vim-test/vim-test"
    use "tpope/vim-commentary"
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
    use { 'dracula/vim', as = 'dracula' }
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
    use "vim-airline/vim-airline"
    use "vim-airline/vim-airline-themes"
  end
}
