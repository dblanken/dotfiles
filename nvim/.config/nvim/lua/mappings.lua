local function map(mode, lhs, rhs, opts)
  local options = {noremap = true, silent = true}
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local cmd = vim.cmd
local opt = {}

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Easy macro playback
map('n', 'Q', 	      '@q',         opt)
-- Format the whole document
map('n', '<Leader>=', 'migg=G`i',   opt)
-- Yank to end of line
map('n', 'Y',         'y$',         opt)
-- Escape to normal mode on terminal
map('t', '<Esc>',     '<C-\\><C-n>', opt)

-- compe stuff
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col(".") - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
    return true
  else
    return false
  end
end

_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif require('luasnip').expand_or_jumpable() then
    return t "<cmd>lua require'luasnip'.jump(1)<Cr>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn["compe#complete"]()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif require("luasnip").jumpable(-1) then
    return t "<cmd>lua require'luasnip'.jump(-1)<CR>"
  else
    return t "<S-Tab>"
  end
end

function _G.completions()
  local npairs
  if
    not pcall(
    function()
      npairs = require "nvim-autopairs"
    end
    )
    then
      return
    end

    if vim.fn.pumvisible() == 1 then
      if vim.fn.complete_info()["selected"] ~= -1 then
        return vim.fn["compe#confirm"]("<CR>")
      end
    end
    return npairs.check_break_line_char()
  end

  function _G.jump_or_expand_if_can(mapping)
    if require('luasnip').expand_or_jumpable() then
      return t "<cmd>lua require'luasnip'.expand_or_jump()<Cr>"
      else
        return t(mapping)
    end
  end

  function _G.jump_back(mapping)
    if require('luasnip').jumpable(-1) then
      return t "<cmd>lua require'luasnip'.jump(-1)<Cr>"
      else
        return t(mapping)
    end
  end

  --  compe mappings
  map("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
  map("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
  map("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
  map("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
  map("i", "<CR>", "v:lua.completions()", {expr = true})
  map("i", "<C-j>", "v:lua.jump_or_expand_if_can('<C-j>')", {expr = true})
  map("i", "<C-k>", "v:lua.jump_back('<C-k>')", {expr = true})

  -- Telescope
  map("n", "<Leader>ff", [[<Cmd>lua require('telescope.builtin').find_files() <CR>]],                                 opt)
  map("n", "<Leader>fg", [[<Cmd>lua require('telescope.builtin').live_grep()<CR>]],                                    opt)
  map("n", "<Leader>fb", [[<Cmd>lua require('telescope.builtin').buffers()<CR>]],                                     opt)
  map("n", "<Leader>fh", [[<Cmd>lua require('telescope.builtin').help_tags()<CR>]],                                   opt)
  map("n", "<Leader>fn", [[<Cmd>lua require('plugins.telescope_custom').edit_neovim()<CR>]], opt)

  -- Packer commands till because we are not loading it at startup
  cmd("silent! command PackerCompile lua require 'plugins' require('packer').compile()")
  cmd("silent! command PackerInstall lua require 'plugins' require('packer').install()")
  cmd("silent! command PackerStatus lua require 'plugins' require('packer').status()")
  cmd("silent! command PackerSync lua require 'plugins' require('packer').sync()")
  cmd("silent! command PackerUpdate lua require 'plugins' require('packer').update()")
