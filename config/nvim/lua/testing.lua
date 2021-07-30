-- vim-test mappings
vim.api.nvim_set_keymap('n', '<Leader>t', ':TestNearest<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>T', ':TestFile<CR>',    { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>a', ':TestSuite<CR>',   { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>l', ':TestLast<CR>',    { noremap = true, silent = true })
vim.g['test#strategy'] = 'dispatch'

if vim.g.dockerized == 1 then
  vim.g['test#ruby#rails#executable'] = 'docker compose exec web bundle exec rails test'
end

