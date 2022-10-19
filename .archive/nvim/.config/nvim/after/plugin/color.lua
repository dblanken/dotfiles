vim.opt.background = 'dark'

if vim.fn.exists(vim.env["BASE16_THEME"]) and
  vim.g.colors_name == ''
  or vim.g.colors_name ~= "base16-" .. vim.env["BASE16_THEME"] then
  vim.cmd("colorscheme base16-" .. vim.env["BASE16_THEME"])

  -- Hide (or at least make less obvious) the EndOfBuffer region
  -- vim.cmd('highlight! EndOfBuffer ctermbg=bg ctermfg=bg guibg=bg guifg=bg')
end

local dark = vim.o.background == 'dark'

-- Grey, just like we used to get with https://github.com/Yggdroot/indentLine
vim.cmd('highlight clear Conceal')
if dark then
  vim.cmd('highlight Conceal ctermfg=239 guifg=Grey30')
  vim.cmd('highlight IndentBlanklineChar guifg=Grey10 gui=nocombine')
else
  vim.cmd('highlight Conceal ctermfg=249 guifg=Grey70')
  vim.cmd('highlight IndentBlanklineChar guifg=Grey90 gui=nocombine')
end

vim.cmd [[
highlight clear NonText
highlight link NonText Conceal
highlight clear CursorLineNr
]]
vim.cmd [[
highlight clear Pmenu
highlight link Pmenu Visual
" See :help 'pb'.
highlight PmenuSel blend=0
highlight clear DiffDelete
highlight link DiffDelete Conceal
highlight clear VertSplit
highlight link VertSplit LineNr
" Resolve clashes with ColorColumn.
" Instead of linking to Normal (which has a higher priority, link to nothing).
highlight link vimUserFunc NONE
]]

-- More subtle highlighting during merge conflict resolution.
vim.cmd [[
highlight clear DiffAdd
highlight clear DiffChange
highlight clear DiffText
]]
