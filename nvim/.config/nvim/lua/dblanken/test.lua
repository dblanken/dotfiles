local opts = { silent = true }

vim.api.nvim_set_keymap('n', '<leader>t', ':TestNearest<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>T', ':TestFile<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>a', ':TestSuite<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>l', ':TestLast<CR>', opts)

vim.g["test#strategy"] = 'dispatch'
