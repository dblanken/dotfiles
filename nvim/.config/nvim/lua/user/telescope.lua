local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

telescope.setup {}

local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap("n", "<Leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", opts)
vim.api.nvim_set_keymap("n", "<Leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", opts)
vim.api.nvim_set_keymap("n", "<Leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", opts)
