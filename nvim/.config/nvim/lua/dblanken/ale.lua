local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', ']d', '<Plug>(ale_next_wrap)', opts)
vim.api.nvim_set_keymap('n', '[d', '<Plug>(ale_previous_wrap)', opts)
vim.g.ale_echo_msg_format = '[%linter%] %code: %%s'
