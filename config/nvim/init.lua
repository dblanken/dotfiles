vim.g.mapleader = ' '

require('options')

-- Used throughout
vim.g.ErrorSign = ''
vim.g.WarningSign = ''
vim.g.InformationSign = ''
vim.g.HintSign = ''
vim.g.lsp_icon = ' '

-- Generic mappings
vim.api.nvim_set_keymap('n', '<Leader>=', 'migg=G`i',     { noremap = true })
vim.api.nvim_set_keymap('n', 'Y',         'y$',           { noremap = true })
vim.api.nvim_set_keymap('n', 'Q',         '@q',           { noremap = true })
vim.api.nvim_set_keymap('t', '<Esc>',     '<C-\\><C-n>',  { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Leader>p', '"_dP',         { noremap = true })

-- Center searching
vim.api.nvim_set_keymap('n', 'n',         'nzzzv',        { noremap = true })
vim.api.nvim_set_keymap('n', 'N',         'Nzzzv',        { noremap = true })
vim.api.nvim_set_keymap('n', 'J',         'mzJ`z',        { noremap = true })

-- Undo breaks
vim.api.nvim_set_keymap('i', ',',         ',<c-g>u',      { noremap = true })
vim.api.nvim_set_keymap('i', '.',         '.<c-g>u',      { noremap = true })
vim.api.nvim_set_keymap('i', '!',         '!<c-g>u',      { noremap = true })
vim.api.nvim_set_keymap('i', '?',         '?<c-g>u',      { noremap = true })
vim.api.nvim_set_keymap('i', '(',         '(<c-g>u',      { noremap = true })
vim.api.nvim_set_keymap('i', '[',         '[<c-g>u',      { noremap = true })

-- k/j jumplists
vim.api.nvim_set_keymap('n', 'k',         '(v:count > 5 ? "m\'" . v:count : "") . "k"',      { expr = true, noremap = true })
vim.api.nvim_set_keymap('n', 'j',         '(v:count > 5 ? "m\'" . v:count : "") . "j"',      { expr = true, noremap = true })

-- Moving lines around
vim.api.nvim_set_keymap('v', 'J',         ':m \'>+1<CR>gv=gv', { noremap = true })
vim.api.nvim_set_keymap('v', 'K',         ':m \'<-2<CR>gv=gv', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-j>',     ':m .+1<CR>==',      { noremap = true })
vim.api.nvim_set_keymap('i', '<C-k>',     ':m .-2<CR>==',      { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>J', ':m .+1<CR>==',      { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>K', ':m .-2<CR>==',      { noremap = true })


-- vim-rails projections
vim.g.rails_projections = '{ "test/models/*_test.rb": {"command": "modeltest", "template": ["require \"test_helper\"", "", "class {camelcase|capitalize|colons}Test < ActiveSupport::TestCase", "end"] } }'

-- Misc autocmds
vim.cmd [[
augroup misc
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' | exe "normal! g`\"" | endif
  autocmd VimResized * execute "normal! \<c-w>="
  autocmd FileType ruby,eruby,yaml setlocal iskeyword+=?
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {"IncSearch", 200}
augroup END
]]

-- grep
if vim.fn.executable('rg') then
  vim.opt.grepprg="rg --no-heading --vimgrep --smart-case"
end

require('plugins')
require('lsp')
require('telescoping')
require('flagship')
require('testing')

vim.cmd [[ colorscheme dracula ]]
