vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Disable built-ins
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1

vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1

vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1

-- Options
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.foldlevel = 99
vim.opt.clipboard="unnamedplus"
vim.opt.termguicolors = true

-- Generic mappings
local opts = { noremap = true, silent = true }
local expr_opts = vim.tbl_extend("force", opts, { expr = true })

vim.api.nvim_set_keymap('n', 'Q', '@q', opts)
vim.api.nvim_set_keymap('n', '<Leader>=', 'migg=G`i', opts)
vim.api.nvim_set_keymap('n', 'Y', 'y$', opts)
vim.api.nvim_set_keymap('n', '<Leader>h', ':nohl<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader><Leader>', '<C-^>', opts)

vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', opts)

vim.api.nvim_set_keymap('n', 'n', 'nzzzv', opts)
vim.api.nvim_set_keymap('n', 'N', 'Nzzzv', opts)
vim.api.nvim_set_keymap('n', 'J', 'mzJ`z', opts)

local breakpoint_keys = {
  ",", ".", "!", "?", "=", "[", "]", "{", "}"
}
for _, key in pairs(breakpoint_keys) do
  vim.api.nvim_set_keymap('i', key, key .. '<c-g>u', opts)
end

vim.api.nvim_set_keymap('n', 'k', '(v:count > 5 ? "m\'" . v:count : "") . "k"', expr_opts)
vim.api.nvim_set_keymap('n', 'j', '(v:count > 5 ? "m\'" . v:count : "") . "j"', expr_opts)

vim.api.nvim_set_keymap('v', '<', '<gv', opts)
vim.api.nvim_set_keymap('v', '>', '>gv', opts)

vim.api.nvim_set_keymap('v', 'y', 'myy`y', opts)
vim.api.nvim_set_keymap('v', 'Y', 'myY`y', opts)

vim.api.nvim_set_keymap('v', 'J', ":m '>+1<CR>gv=gv", opts)
vim.api.nvim_set_keymap('v', 'K', ":m '<-2<CR>gv=gv", opts)

vim.api.nvim_set_keymap('i', ';;', '<Esc>A;<Esc>', opts)
vim.api.nvim_set_keymap('i', ',,', '<Esc>A,<Esc>', opts)

-- Autocmds
vim.cmd [[
augroup misc
  autocmd!

  " When resized, resize the windows inside
  autocmd VimResized * execute "normal! \<c-w>="

  " Nest source on changes to vimrc
  autocmd BufWritePost .vimrc,init.vim,vimrc nested source %

  autocmd BufEnter,BufNewFile .zshrc,zshrc setlocal filetype=zsh

  autocmd BufWritePre * :call whitespace#trim()

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  "
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
augroup end

augroup dblanken_filetypes
  autocmd FileType * setlocal nolinebreak
  autocmd FileType xml,xsd,xslt,javascript setlocal ts=2
  autocmd FileType mail,gitcommit setlocal tw=72 spell
  autocmd FileType sh,zsh,csh,tcsh setlocal fo-=t|
        \ inoremap <silent> <buffer> <C-X>! #!/bin/<C-R>=&ft<CR>
  autocmd FileType perl,python,ruby,tcl
        \ inoremap <silent> <buffer> <C-X>! #!/usr/bin/env<Space><C-R>=&ft<CR>
  autocmd FileType javascript
        \ inoremap <silent> <buffer> <C-X>! #!/usr/bin/env<Space>node
  autocmd FileType help setlocal ai formatoptions+=2n nospell
  autocmd FileType ruby setlocal comments=:#\ tw=78
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd FileType liquid,markdown,text,txt setlocal tw=78 linebreak keywordprg=dict spell
augroup END
]]

-- Grep
local function setupGrepProgram()
  if vim.fn.executable('rg') then
    return 'rg --no-heading --vimgrep --smart-case'
  elseif vim.fn.executable('ag') then
    return 'ag --nogroup --nocolor'
  end

  return vim.o.grepprg
end

vim.opt.grepprg = setupGrepProgram()
