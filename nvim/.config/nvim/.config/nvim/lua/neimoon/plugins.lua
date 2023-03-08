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
    config = function()
      vim.cmd('colorscheme rose-pine')
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { {'nvim-lua/plenary.nvim'} }
  },
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    dependencies = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},             -- Required
      {'williamboman/mason.nvim'},           -- Optional
      {'williamboman/mason-lspconfig.nvim'}, -- Optional

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},         -- Required
      {'hrsh7th/cmp-nvim-lsp'},     -- Required
      {'hrsh7th/cmp-buffer'},       -- Optional
      {'hrsh7th/cmp-path'},         -- Optional
      {'saadparwaiz1/cmp_luasnip'}, -- Optional
      {'hrsh7th/cmp-nvim-lua'},     -- Optional

      -- Snippets
      {'L3MON4D3/LuaSnip'},             -- Required
      {'rafamadriz/friendly-snippets'}, -- Optional
    }
  },
  -- {
  --   "folke/trouble.nvim",
  --   config = function()
  --     require("trouble").setup {
  --       icons = false,
  --     }
  --   end
  -- },
  {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  },
  { 'nvim-treesitter/nvim-treesitter-context' },
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-surround' },
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
  { 'tribela/vim-transparent' },
  { 'vimwiki/vimwiki' },
  { 'christoomey/vim-tmux-navigator' },
})
