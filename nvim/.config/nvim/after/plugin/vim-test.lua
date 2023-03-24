vim.keymap.set('n', '<Leader>t', '<cmd>:TestNearest<CR>')
vim.keymap.set('n', '<Leader>T', '<cmd>:TestFile<CR>')
vim.keymap.set('n', '<Leader>a', '<cmd>:TestSuite<CR>')
vim.keymap.set('n', '<Leader>l', '<cmd>:TestLast<CR>')
vim.g["test#strategy"] = 'dispatch'

-- Don't run over and over; run once and allow me to test a different area the next time
vim.g["test#javascript#reactscripts#executable"] = "node_modules/.bin/react-scripts test --watchAll=false"
