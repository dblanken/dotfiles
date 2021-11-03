if !has_key(g:plugs, 'lightline.vim') || !has_key(g:plugs, 'vim-webdevicons')
  source ~/.config/nvim/plugins/lightline.vim
  source ~/.config/nvim/plugins/webdevicons.vim
endif

function! DevIconsFromFileType() abort
  let l:icon = luaeval('require"nvim-web-devicons".get_icon(vim.fn.expand("%"), vim.fn.expand("%:e"), {})')
  return l:icon
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . DevIconsFromFileType() : 'no ft') : ''
endfunction

function! AppendWebDevLightLineAttributes() abort
  let l:component_function = g:lightline.component_function
  let l:component_function.filetype = 'MyFiletype'

  return l:component_function
endfunction

augroup LightlineWebDevIconsOverrides
  autocmd!
  autocmd User PlugLoaded let g:lightline.component_function = AppendWebDevLightLineAttributes()
augroup END
