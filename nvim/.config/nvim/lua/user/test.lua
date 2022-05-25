vim.api.nvim_set_keymap('n', '<Leader>t', ':TestNearest<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>T', ':TestFile<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>a', ':TestSuite<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>l', ':TestLast<CR>', { silent = true })
vim.g['test#strategy'] = 'dispatch'
