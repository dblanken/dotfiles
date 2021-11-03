Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'

let g:lightline = {
      \  'colorscheme': 'gruvbox',
      \  'show_buffer_number': 1,
      \  'active': {
      \    'left': [ [ 'mode', 'paste' ],
      \              [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \  },
      \  'component_function': {
      \    'gitbranch': 'FugitiveHead'
      \   }
      \ }
