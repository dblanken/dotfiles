local opts = { silent = true }

vim.api.nvim_set_keymap('n', '<leader>t', ':TestNearest', opts)
vim.api.nvim_set_keymap('n', '<leader>T', ':TestFile', opts)
vim.api.nvim_set_keymap('n', '<leader>a', ':TestSuite', opts)
vim.api.nvim_set_keymap('n', '<leader>l', ':TestLast', opts)

vim.g["test#strategy"] = 'dispatch'
