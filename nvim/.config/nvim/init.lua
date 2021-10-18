require 'plugins'
require 'disable_builtins'

vim.g.mapleader = " "

-- Force loading of astronauta so we can use nnoremap goodness
vim.cmd [[runtime plugin/astronauta.vim]]

require 'lsp'

vim.g.my_color_scheme = 'dracula'
