local function map(mode, lhs, rhs, opts)
  local options = {noremap = true, silent = true}
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local cmd = vim.cmd
local opt = {}

vim.g.mapleader = " "

map('n', 'Q', '@q', opt)
map('n', '<Leader>=', 'migg=G`i', opt)
map('n', 'Y', 'y$', opt)
map('t', '<Esc>', '<C-\\><C-n>', opt)

map('n', '<Leader>t', ':TestNearest<CR>', opt)
map('n', '<Leader>T', ':TestFile<CR>', opt)
map('n', '<Leader>a', ':TestSuite<CR>', opt)
map('n', '<Leader>l', ':TestLast<CR>', opt)
vim.g['test#strategy'] = 'dispatch'

map('n', '<Leader>ff', '<cmd>lua require("telescope.builtin").find_files()<CR>', opt)
map('n', '<Leader>fg', '<cmd>lua require("telescope.builtin").live_grep()<CR>', opt)
map('n', '<Leader>fn', '<cmd>lua require("plugins.dblanken.telescope").edit_neovim()<CR>', opt)
map('n', '<C-p>', '<cmd>lua require("telescope.builtin").find_files()<CR>', opt)

if use_builtin_lsp then
  local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end

  local check_back_space = function()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
  end

  -- Use (s-)tab to:
  --- move to prev/next item in completion menuone
  --- jump to prev/next snippet's placeholder
  _G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
      return t "<C-n>"
    elseif vim.fn['vsnip#available'](1) == 1 then
      return t "<Plug>(vsnip-expand-or-jump)"
    elseif check_back_space() then
      return t "<Tab>"
    else
      return vim.fn['compe#complete']()
    end
  end
  _G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
      return t "<C-p>"
    elseif vim.fn['vsnip#jumpable'](-1) == 1 then
      return t "<Plug>(vsnip-jump-prev)"
    else
      -- If <S-Tab> is not working in your terminal, change it to <C-h>
      return t "<S-Tab>"
    end
  end

  vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
  vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
  vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
  vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

  map('i', '<C-Space>', "compe#complete()", {expr = true})
  map('i', '<CR>', "compe#confirm('<CR>')", {expr = true})
  map('i', '<C-e>', "compe#close('<C-e>')", {expr = true})
  map('i', '<C-f>', "compe#scroll({ 'delta': +4 })", {expr = true})
  map('i', '<C-d>', "compe#scroll({ 'delta': -4 })", {expr = true})

  map('n', 's', '<Plug>(vsnip-select-text)', {noremap=false,silent=false})
  map('x', 's', '<Plug>(vsnip-select-text)', {noremap=false,silent=false})
  map('n', 'S', '<Plug>(vsnip-cut-text)', {noremap=false,silent=false})
  map('x', 'S', '<Plug>(vsnip-cut-text)', {noremap=false,silent=false})
end

-- Packer commands till because we are not loading it at startup
vim.cmd("silent! command PackerCompile lua require 'pluginList' require('packer').compile()")
vim.cmd("silent! command PackerInstall lua require 'pluginList' require('packer').install()")
vim.cmd("silent! command PackerStatus lua require 'pluginList' require('packer').status()")
vim.cmd("silent! command PackerSync lua require 'pluginList' require('packer').sync()")
vim.cmd("silent! command PackerUpdate lua require 'pluginList' require('packer').update()")
vim.cmd("silent! command PackerProfile lua require 'pluginList' require('packer').profile_output()")
vim.cmd("silent! command PackerCompileProfile lua require 'pluginList' require('packer').compile('profile=true')")
