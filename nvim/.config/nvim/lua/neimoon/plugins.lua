local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { 'folke/lazy.nvim' },
  {                                                 -- Fallback Colorscheme
    'rose-pine/neovim',
    as = 'rose-pine',
  },
  {                                                 -- Fuzzy finding
    'nvim-telescope/telescope.nvim',
    dependencies = { { 'nvim-lua/plenary.nvim' } },
  },
  {                                                 -- lsp/completion/snippets
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' }, -- Required
      {
        'williamboman/mason.nvim',
        build = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },         -- Required
      { 'hrsh7th/cmp-nvim-lsp' },     -- Required
      { 'hrsh7th/cmp-buffer' },       -- Optional
      { 'hrsh7th/cmp-path' },         -- Optional
      { 'saadparwaiz1/cmp_luasnip' }, -- Optional
      { 'hrsh7th/cmp-nvim-lua' },     -- Optional

      -- Snippets
      {
        'L3MON4D3/LuaSnip',
        dependencies = {
          { 'rafamadriz/friendly-snippets' },
        },
      },             -- Required
    },
  },
  {                                                   -- diagnostics in quickfix
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup {
        icons = true,
      }
    end,
  },
  {                                                   -- better highlighting and more
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  },
  { 'nvim-treesitter/nvim-treesitter-context' },      -- better contexts
  { 'tpope/vim-fugitive' },                           -- git
  { 'tpope/vim-commentary' },                         -- commenting
  { 'tpope/vim-projectionist' },                      -- easy traversal
  { 'tpope/vim-dispatch' },                           -- async "make"
  { 'tpope/vim-sleuth' },                             -- tabstops based on files around it
  { 'tpope/vim-unimpaired' },                         -- [] commands
  { 'tpope/vim-eunuch' },                             -- Unix cmds in vim
  { 'tpope/vim-repeat' },                             -- . command plugin repeat
  { 'tpope/vim-vinegar' },                            -- '-' for netrw
  { 'tpope/vim-apathy' },                             -- find paths automagically
  { 'tpope/vim-abolish' },                            -- Fix/substitution
  { 'tribela/vim-transparent' },                      -- Make vim transparent
  { 'vimwiki/vimwiki' },                              -- Notes
  {                                                   -- vim-tmux-navigator
    'numToStr/Navigator.nvim',
    config = true,
    keys = {
      {
        mode = { "n", "t" },
        "<C-h>",
        "<CMD>NavigatorLeft<CR>",
        desc = "Navigate left",
      },
      {
        mode = { "n", "t" },
        "<C-l>",
        "<CMD>NavigatorRight<CR>",
        desc = "Navigate right",
      },
      {
        mode = { "n", "t" },
        "<C-k>",
        "<CMD>NavigatorUp<CR>",
        desc = "Navigate up",
      },
      {
        mode = { "n", "t" },
        "<C-j>",
        "<CMD>NavigatorDown<CR>",
        desc = "Navigate down",
      },
    },
  },
  { 'vim-test/vim-test' },                              -- Easier testing
  {                                                     -- colorize hex colors
    'norcalli/nvim-colorizer.lua',
    main = 'colorizer',
    config = function()
      require('colorizer').setup({
        '*';
      }, { css = true })
    end,
  },
  { 'mfussenegger/nvim-dap' },                          -- Debug adapter
  { 'rcarriga/nvim-dap-ui' },                           -- UI for dap
  { 'theHamsta/nvim-dap-virtual-text' },                -- Virtual text for dap
  { 'nvim-telescope/telescope-dap.nvim' },              -- Telescope dap
  {                                                     -- See markdown while editing
    'iamcco/markdown-preview.nvim',
    build = function() vim.fn["mkdp#util#install"]() end
  },
  { 'mxsdev/nvim-dap-vscode-js' },                      -- dap adapter for vscode-js-debug
  {                                                     -- vscode-js-debug
    'microsoft/vscode-js-debug',
    lazy = true,
    build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
  },
  {                                                     -- lua copilot
    'zbirenbaum/copilot.lua',
    config = function()
      require('copilot').setup({
        suggestion = {enabled = false},
        panel = {enabled = false},
      })
    end
  },
  {                                                     -- copilot for cmp
    "zbirenbaum/copilot-cmp",
    config = function ()
      require("copilot_cmp").setup()
    end
  },
  { 'nvim-lualine/lualine.nvim' },
  { 'nvim-tree/nvim-web-devicons' },
  {
    'RRethy/nvim-base16',
    config = function()
      vim.cmd('colorscheme base16-' .. vim.env["BASE16_THEME"])
    end
  },
  { 'fgheng/winbar.nvim' },
  { 'SmiteshP/nvim-navic' },
  {
    'Wansmer/treesj',
    keys = {
      {
        "<Leader>sj",
        "<CMD>TSJToggle<CR>",
        desc = "Toggle Treesitter Join",
      }
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    opts = { use_default_keymaps = false },
  },
  {
    "f-person/git-blame.nvim",
    keys = {
      {
        "<Leader>gb",
        "<CMD>GitBlameToggle<CR>",
        desc = "Toggle Git Blame",
      },
    },
    init = function()
      vim.g.gitblame_enabled = 0
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    main = "nvim-surround",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    "nvim-lua/lsp-status.nvim",
    config = function()
      require("lsp-status").register_progress()
    end,
  },
  {
    "jamestthompson3/nvim-remote-containers"
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
  },
})
