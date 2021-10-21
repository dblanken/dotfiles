let g:my_colorscheme = 'dracula'

" Skip home grown tab completion since we use a plugin
let g:tab_completion_loaded = 1
let g:lsp_plugin = 'ale'

" Space is a sane leader key
let mapleader="\<Space>"

" Automatically install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(data_dir . '/plugins')

source ~/.config/nvim/plugins/ale.vim
source ~/.config/nvim/plugins/bundler.vim
source ~/.config/nvim/plugins/camel_case_motion.vim
" source ~/.config/nvim/plugins/nvim/cmp.vim
source ~/.config/nvim/plugins/commentary.vim
" source ~/.config/nvim/plugins/coc.vim
" source ~/.config/nvim/plugins/nvim/lsp.vim
source ~/.config/nvim/plugins/dispatch.vim
source ~/.config/nvim/plugins/dracula.vim
source ~/.config/nvim/plugins/endwise.vim
source ~/.config/nvim/plugins/eunuch.vim
source ~/.config/nvim/plugins/fugitive.vim
" source ~/.config/nvim/plugins/fzf.vim
" source ~/.config/nvim/plugins/gruvbox.vim
source ~/.config/nvim/plugins/onedark.vim
source ~/.config/nvim/plugins/projectionist.vim
source ~/.config/nvim/plugins/rails.vim
source ~/.config/nvim/plugins/rake.vim
source ~/.config/nvim/plugins/repeat.vim
source ~/.config/nvim/plugins/ruby.vim
source ~/.config/nvim/plugins/sideways.vim
source ~/.config/nvim/plugins/splitjoin.vim
source ~/.config/nvim/plugins/sleuth.vim
source ~/.config/nvim/plugins/snippets.vim
source ~/.config/nvim/plugins/statusline.vim
source ~/.config/nvim/plugins/surround.vim
source ~/.config/nvim/plugins/tabular.vim
source ~/.config/nvim/plugins/telescope.vim
source ~/.config/nvim/plugins/textobj-rubyblock.vim
source ~/.config/nvim/plugins/test.vim
source ~/.config/nvim/plugins/unimpaired.vim
source ~/.config/nvim/plugins/tmux-navigator.vim

call plug#end()
" Perform all of our setups for all plugins
doautocmd User PlugLoaded
