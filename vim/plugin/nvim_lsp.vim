if !has('nvim')
  finish
endif

augroup FormatOnSave
  autocmd!
  autocmd BufWritePre *.rb,*.js,*.es6,*.sh,*.css,*.html,*.html.erb,*.py lua vim.lsp.buf.formatting_sync({}, 500)
augroup END

" Statusline
function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction

autocmd User Flags call Hoist("buffer", "LspStatus")

