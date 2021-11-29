local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<Leader>t', ':TestNearest<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>T', ':TestFile<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>a', ':TestSuite<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>l', ':TestLast<CR>', opts)
vim.g['test#strategy'] = 'dispatch'
