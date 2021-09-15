augroup dblanken
  autocmd!

  " Auto re-source on save
  autocmd BufWritePost .vimrc,init.vim,init.lua,vimrc,pluginList.lua nested source %
  " Auto resize windows
  autocmd VimResized * execute "normal! \<C-w>="
  " Highlighted yank
  autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=250}
  " Make ? part of a keyword
  autocmd FileType ruby,eruby,yaml setlocal iskeyword+=?
augroup END
