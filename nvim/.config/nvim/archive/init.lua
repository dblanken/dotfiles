-- Install Lazy.nvim
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

vim.g.mapleader = ' '

require("lazy").setup({
  "tpope/vim-abolish",
  "tpope/vim-apathy",
  "tpope/vim-bundler",
  "tpope/vim-commentary",
  "tpope/vim-dadbod",
  "tpope/vim-dispatch",
  "tpope/vim-endwise",
  "tpope/vim-eunuch",
  "tpope/vim-flagship",
  "tpope/vim-fugitive",
  "tpope/vim-git",
  "tpope/vim-jdaddy",
  "tpope/vim-markdown",
  "tpope/vim-projectionist",
  "tpope/vim-ragtag",
  "tpope/vim-rails",
  "tpope/vim-rake",
  "tpope/vim-repeat",
  "tpope/vim-rhubarb",
  "tpope/vim-sleuth",
  "tpope/vim-speeddating",
  "tpope/vim-surround",
  { "tpope/vim-unimpaired", lazy = true, keys = { "[f", "]f" } },
  "tpope/vim-vinegar",
  "ludovicchabant/vim-gutentags", -- Automatic tags management
  { "nvim-treesitter/nvim-treesitter", run = "TSUpdate" },
  "vim-test/vim-test", -- Rails testing
  { "vimwiki/vimwiki", lazy = true, keys = { "<Leader>ww" } }, -- For documentation
  "tribela/vim-transparent", -- Transparency
  "christoomey/vim-tmux-navigator", -- Easy Tmux/vim navigation
  "wincent/base16-nvim", -- For nvim and terminal color matching
})


vim.bo.textwidth = 80
vim.wo.colorcolumn = '+1'

--Set highlight on search
vim.o.hlsearch = true

--Make line numbers default
vim.wo.number = true

--Make line numbers relative to the cursor
vim.wo.relativenumber = true

--Enable mouse mode
vim.o.mouse = 'a'

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

--Set colorscheme
vim.o.termguicolors = true
-- vim.cmd [[colorscheme onedark]]
if vim.fn.exists('$BASE16_THEME') and (not vim.fn.exists('g:colors_name') or vim.g.colors_name ~= 'base16-$BASE16_THEME') then
  vim.g.base16colorspace = 256
  vim.cmd [[colorscheme base16-$BASE16_THEME]]
end

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- vim-test
vim.keymap.set('n', '<leader>t', ":TestNearest<CR>")
vim.keymap.set('n', '<leader>T', ":TestFile<CR>")
vim.keymap.set('n', '<leader>a', ":TestSuite<CR>")
vim.keymap.set('n', '<leader>l', ":TestLast<CR>")
vim.keymap.set('n', '<leader>C', ":TestClass<CR>")
vim.g["test#strategy"] = "dispatch"

-- vim-wiki
vim.g.vimwiki_list = {
  {
    path = '~/vimwiki',
    syntax = 'markdown',
    ext = '.md'
  },
  {
    path = '~/code/vimwiki',
    syntax = 'markdown',
    ext = '.md'
  }
 }

-- vim: ts=2 sts=2 sw=2 et
