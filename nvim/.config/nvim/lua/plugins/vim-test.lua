local function map(mode, lhs, rhs, opts)
  local options = {noremap = true, silent = true}
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local opts = { noremap = false }
local g = vim.g

map('n', '<Leader>t', ':TestNearest<CR>', opts)
map('n', '<Leader>T', ':TestFile<CR>', opts)
map('n', '<Leader>a', ':TestSuite<CR>', opts)
map('n', '<Leader>l', ':TestLast<CR>', opts)

g['test#strategy'] = 'dispatch'
