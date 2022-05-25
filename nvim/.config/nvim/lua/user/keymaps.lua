local g = vim.g
local api = vim.api
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }
local expr_opts = vim.tbl_extend("force", opts, { expr = true })

-- Leaders
api.nvim_set_keymap("", "<Space>", "<Nop>", opts)
g.mapleader = " "
g.maplocalleader = "\\"

-- Generic keymaps
api.nvim_set_keymap('n', 'Q', '@q', opts)
api.nvim_set_keymap('n', '<Leader>=', 'migg=G`i', opts)
api.nvim_set_keymap('n', 'Y', 'y$', opts)
api.nvim_set_keymap('n', '<Leader>h', ':nohl<CR>', opts)
api.nvim_set_keymap('n', '<Leader><Leader>', '<C-^>', opts)

api.nvim_set_keymap('n', 'n', 'nzzzv', opts)
api.nvim_set_keymap('n', 'N', 'Nzzzv', opts)
api.nvim_set_keymap('n', 'J', 'mzJ`z', opts)

api.nvim_set_keymap('n', 'k', '(v:count > 5 ? "m\'" . v:count : "") . "k"', expr_opts)
api.nvim_set_keymap('n', 'j', '(v:count > 5 ? "m\'" . v:count : "") . "j"', expr_opts)

api.nvim_set_keymap('v', '<', '<gv', opts)
api.nvim_set_keymap('v', '>', '>gv', opts)

api.nvim_set_keymap('v', 'y', 'myy`y', opts)
api.nvim_set_keymap('v', 'Y', 'myY`y', opts)

api.nvim_set_keymap('v', 'J', ":m '>+1<CR>gv=gv", opts)
api.nvim_set_keymap('v', 'K', ":m '<-2<CR>gv=gv", opts)

api.nvim_set_keymap('i', ';;', '<Esc>A;<Esc>', opts)
api.nvim_set_keymap('i', ',,', '<Esc>A,<Esc>', opts)

local breakpoint_keys = {
  ",", ".", "!", "?", "=", "[", "]", "{", "}"
}
for _, key in pairs(breakpoint_keys) do
  api.nvim_set_keymap('i', key, key .. '<c-g>u', opts)
end

api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', opts)
