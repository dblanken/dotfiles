vim.cmd [[packadd packer.nvim]]

return require('packer').startup {
    function(use)
        use { 'wbthomason/packer.nvim' }

        -- Utility plugins
        use 'nvim-lua/popup.nvim'
        use { 'nvim-lua/plenary.nvim', rocks = 'lyaml' }
        use 'kyazdani42/nvim-web-devicons'

        -- The real deals
        use 'tpope/vim-projectionist'
        use 'tpope/vim-dadbod'
        use {
            'bkad/CamelCaseMotion',
            config = function()
                require 'plugins.camel_case_motion'
            end,
        }
        use 'christoomey/vim-tmux-navigator'
        use 'digitaltoad/vim-pug'
        use {
            'neovim/nvim-lspconfig',
            config = function()
                require 'plugins.lsp'
            end
        }
        use 'romainl/vim-qf'
        use 'tpope/vim-abolish'
        use 'tpope/vim-bundler'
        use 'tpope/vim-commentary'
        use 'tpope/vim-dispatch'
        use 'tpope/vim-eunuch'
        use 'tpope/vim-fugitive'
        use 'tpope/vim-rails'
        use 'tpope/vim-rake'
        use 'tpope/vim-repeat'
        use 'tpope/vim-surround'
        use 'tpope/vim-unimpaired'
        -- use 'tpope/vim-vinegar'
        use 'vim-ruby/vim-ruby'
        use {
            'vim-test/vim-test',
            config = function()
                require 'plugins.test'
            end,
        }
        use {
            'nvim-telescope/telescope.nvim',
            requires = { {'nvim-lua/plenary.nvim'} },
            config = function()
                require "plugins.telescope"
            end,
        }
        use { 'AndrewRadev/splitjoin.vim', keys = { 'gJ', 'gS' } }
        use {
            'iamcco/markdown-preview.nvim',
            ft = 'markdown',
            run = 'cd app && yarn install',
            config = function()
                require 'plugins.markdown_preview'
            end,
        }
        use {
            'nvim-treesitter/nvim-treesitter',
            run = ':TSUpdate',
            config = function()
                require 'plugins.treesitter'
            end
        }
        use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
        use {
            'hrsh7th/nvim-cmp',
            requires = {
                { 'hrsh7th/cmp-nvim-lsp' },
                { 'hrsh7th/cmp-buffer' },
                { 'hrsh7th/cmp-path' },
                { 'hrsh7th/cmp-cmdline' },
                { 'hrsh7th/cmp-vsnip' },
                { 'onsails/lspkind-nvim' },
                { 'hrsh7th/cmp-nvim-lua' },
                { 'hrsh7th/vim-vsnip', requires = { { 'rafamadriz/friendly-snippets' } } },
            },
            config = function()
                require 'plugins.cmp'
            end
        }
        use 'github/copilot.vim'
        use {
            'nvim-treesitter/nvim-treesitter-textobjects',
            config = function()
                require 'plugins.treesitter-textobjects'
            end
        }
        use {
            'nvim-treesitter/nvim-treesitter-refactor',
            config = function()
                require 'plugins.treesitter-refactor'
            end
        }
        use 'antonk52/vim-tabber'
        use {
            'lukas-reineke/indent-blankline.nvim',
            config = function()
                require 'plugins.indent-blankline'
            end
        }

        -- Colorschemes
        use { 'dracula/vim', name = 'dracula' }
        use { 'joshdick/onedark.vim', name = 'onedark' }
        use 'gruvbox-community/gruvbox'
        use { 'vim-conf-live/vimconflive2021-colorscheme', name = 'vimconflive2021' }
    end
}
