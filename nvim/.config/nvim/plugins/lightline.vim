Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'

let g:lightline = {
      \  'show_buffer_number': 1,
      \  'active': {
      \    'left': [ [ 'mode', 'paste' ],
      \              [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \  },
      \  'component_function': {
      \    'gitbranch': 'FugitiveHead'
      \   }
      \ }

augroup LightlineOverrides
      autocmd!
      autocmd User PlugLoaded let g:lightline.colorscheme = g:colors_name
augroup END
