local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<Leader>ff', '<cmd>lua require("telescope.builtin").find_files()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>fg', '<cmd>lua require("telescope.builtin").live_grep()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>fb', '<cmd>lua require("telescope.builtin").buffers()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>fh', '<cmd>lua require("telescope.builtin").help_tags()<CR>', opts)

vim.api.nvim_set_keymap('n', '<Leader>en', '<cmd>lua require("dblanken.telescope_customizations").edit_neovim()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>ed', '<cmd>lua require("dblanken.telescope_customizations").edit_dotfiles()<CR>', opts)
