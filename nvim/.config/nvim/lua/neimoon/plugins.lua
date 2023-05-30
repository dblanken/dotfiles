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
  {
    'rose-pine/neovim',
    as = 'rose-pine',
    -- config = function()
    --   vim.cmd('colorscheme rose-pine')
    -- end
  },
  -- {
  --   'wincent/base16-nvim',
  --   config = function()
  --     vim.cmd('colorscheme base16-' .. vim.env["BASE16_THEME"])
  --   end
  -- },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { { 'nvim-lua/plenary.nvim' } },
  },
  {
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
      { 'L3MON4D3/LuaSnip' },             -- Required
      { 'rafamadriz/friendly-snippets' }, -- Optional
    },
  },
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup {
        icons = true,
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  },
  { 'nvim-treesitter/nvim-treesitter-context' },
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-commentary' },
  { 'tpope/vim-projectionist' },
  { 'tpope/vim-dispatch' },
  { 'tpope/vim-sleuth' },
  { 'tpope/vim-unimpaired' },
  { 'tpope/vim-eunuch' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-vinegar' },
  { 'tpope/vim-apathy' },
  { 'tpope/vim-rails' },
  { 'tpope/vim-bundler' },
  { 'tpope/vim-rake' },
  { 'tpope/vim-abolish' },
  { 'tribela/vim-transparent' },
  { 'vimwiki/vimwiki' },
  {
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
  { 'vim-test/vim-test' },
  {
    'norcalli/nvim-colorizer.lua',
    main = 'colorizer',
    config = true,
  },
  { 'mfussenegger/nvim-dap' },
  { 'rcarriga/nvim-dap-ui' },
  { 'theHamsta/nvim-dap-virtual-text' },
  { 'nvim-telescope/telescope-dap.nvim' },
  {
    'iamcco/markdown-preview.nvim',
    build = function() vim.fn["mkdp#util#install"]() end
  },
  { 'mxsdev/nvim-dap-vscode-js' },
  {
    'microsoft/vscode-js-debug',
    lazy = true,
    build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
  },
  { 'burnettk/vim-angular' },
  { 'github/copilot.vim' },
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
    "Bryley/neoai.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    cmd = {
      "NeoAI",
      "NeoAIOpen",
      "NeoAIClose",
      "NeoAIToggle",
      "NeoAIContext",
      "NeoAIContextOpen",
      "NeoAIContextClose",
      "NeoAIInject",
      "NeoAIInjectCode",
      "NeoAIInjectContext",
      "NeoAIInjectContextCode",
    },
    keys = {
      { "<leader>as", desc = "summarize text" },
      { "<leader>ag", desc = "generate git message" },
    },
    config = true,
  },
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
})
