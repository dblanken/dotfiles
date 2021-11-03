if !has_key(g:plugs, 'lightline.vim') || !has_key(g:plugs, 'nvim-lspconfig')
  source ~/.config/nvim/plugins/lightline.vim
  source ~/.config/nvim/plugins/lspconfig.vim
endif

Plug 'josa42/nvim-lightline-lsp'

function! AppendLspLightLineAttributes() abort
  let l:left = g:lightline.active.left
  let l:left = l:left + [[ 'lsp_info', 'lsp_hints', 'lsp_errors', 'lsp_warnings', 'lsp_ok' ]] + [[ 'lsp_status' ]]

  return l:left
endfunction

augroup LightlineLspOverrides
  autocmd!

  autocmd User PlugLoaded let g:lightline.active.left = AppendLspLightLineAttributes()
  autocmd User PlugLoaded call lightline#lsp#register()
augroup END

