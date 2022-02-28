local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd[[packadd packer.nvim]]
end

require('packer').startup({
  function(use)
    use "wbthomason/packer.nvim"

    -- His Popeness
    use "tpope/vim-commentary"
    use "tpope/vim-surround"
    use "tpope/vim-rails"
    use "tpope/vim-projectionist"
    use "tpope/vim-fugitive"
    use "tpope/vim-dispatch"
    use "tpope/vim-unimpaired"
    use "tpope/vim-bundler"
    use "tpope/vim-eunuch"
    use "tpope/vim-rake"
    use "tpope/vim-vinegar"
    use "tpope/vim-endwise"
    use "tpope/vim-repeat"
    use "tpope/vim-git"
    use "tpope/vim-markdown"
    use "tpope/vim-flagship"
    use "tpope/vim-apathy"
    use "tpope/vim-dadbod"
    use "tpope/vim-scriptease"
    use "tpope/vim-abolish"
    use "tpope/vim-rhubarb"
    use "tpope/vim-characterize"
    use "tpope/vim-dotenv"
    use "tpope/vim-obsession"
    use "tpope/vim-speeddating"
    use "tpope/vim-ragtag"
    use "tpope/vim-jdaddy"
    use "tpope/vim-tbone"
    use "tpope/vim-afterimage"

    -- Themes
    use { "gruvbox-community/gruvbox", config = function() require('dblanken.colorscheme') end }

    -- Non-Tpope
    use "christoomey/vim-tmux-navigator"
    use "vim-ruby/vim-ruby"
    use { "vim-test/vim-test", config = function() require('dblanken.test') end }
    -- use { "dense-analysis/ale", config = function() require('dblanken.ale') end }
    use "tribela/vim-transparent"
    use { "vimwiki/vimwiki", config = function() require('dblanken.vimwiki') end }
    use "kchmck/vim-coffee-script"

    -- Lua plugins
    use 'lewis6991/impatient.nvim'
    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate", config = function() require('dblanken.treesitter') end }
    use {
      'nvim-telescope/telescope.nvim',
      requires = { {'nvim-lua/plenary.nvim'} },
      config = function() require('dblanken.telescope') end,
    }
    use {
      { "neovim/nvim-lspconfig", config = function() require('dblanken.lsp') end },
      "williamboman/nvim-lsp-installer",
    }
    use {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
      { 'rafamadriz/friendly-snippets', config = function() require('dblanken.vsnip') end },
      { 'hrsh7th/nvim-cmp', config = function() require('dblanken.cmp') end },
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
      require('packer').sync()
    end
  end,
  config = {
    -- Move to lua dir so impatient.nvim can cache it
    compile_path = vim.fn.stdpath('config')..'/lua/packer_compiled.lua'
  }
})


vim.cmd [[
augroup loadOnSave
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup END
]]
