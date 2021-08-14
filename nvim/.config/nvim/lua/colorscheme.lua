vim.o.background = "dark" -- or "light" for light mode
vim.g.gruvbox_italic = 1
vim.cmd([[colorscheme gruvbox]])
vim.cmd([[
highlight StatusLine guibg=NONE ctermbg=NONE term=NONE cterm=NONE gui=NONE
highlight Normal guibg=NONE ctermbg=NONE
]])
