local opts = { noremap = true, silent = true }
local expr_opts = vim.tbl_extend("force", opts, { expr = true })

vim.api.nvim_set_keymap('n', 'Q', '@q', opts)
vim.api.nvim_set_keymap('n', '<Leader>=', 'migg=G`i', opts)
vim.api.nvim_set_keymap('n', 'Y', 'y$', opts)
vim.api.nvim_set_keymap('n', '<Leader>h', ':nohl<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader><Leader>', '<C-^>', opts)

vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', opts)

vim.api.nvim_set_keymap('n', 'n', 'nzzzv', opts)
vim.api.nvim_set_keymap('n', 'N', 'Nzzzv', opts)
vim.api.nvim_set_keymap('n', 'J', 'mzJ`z', opts)

local breakpoint_keys = {
  ",", ".", "!", "?", "=", "[", "]", "{", "}"
}
for _, key in pairs(breakpoint_keys) do
  vim.api.nvim_set_keymap('i', key, key .. '<c-g>u', opts)
end

vim.api.nvim_set_keymap('n', 'k', '(v:count > 5 ? "m\'" . v:count : "") . "k"', expr_opts)
vim.api.nvim_set_keymap('n', 'j', '(v:count > 5 ? "m\'" . v:count : "") . "j"', expr_opts)

vim.api.nvim_set_keymap('v', '<', '<gv', opts)
vim.api.nvim_set_keymap('v', '>', '>gv', opts)

vim.api.nvim_set_keymap('v', 'y', 'myy`y', opts)
vim.api.nvim_set_keymap('v', 'Y', 'myY`y', opts)

vim.api.nvim_set_keymap('v', 'J', ":m '>+1<CR>gv=gv", opts)
vim.api.nvim_set_keymap('v', 'K', ":m '<-2<CR>gv=gv", opts)

vim.api.nvim_set_keymap('i', ';;', '<Esc>A;<Esc>', opts)
vim.api.nvim_set_keymap('i', ',,', '<Esc>A,<Esc>', opts)
