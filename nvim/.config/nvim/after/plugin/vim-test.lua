vim.keymap.set('n', '<Leader>t', '<cmd>:TestNearest<CR>')
vim.keymap.set('n', '<Leader>T', '<cmd>:TestFile<CR>')
vim.keymap.set('n', '<Leader>a', '<cmd>:TestSuite<CR>')
vim.keymap.set('n', '<Leader>l', '<cmd>:TestLast<CR>')
vim.g["test#strategy"] = 'dispatch'
