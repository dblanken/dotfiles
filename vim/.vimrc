" {{{1 Vim defaults
if !has('nvim')
  unlet! skip_defaults_vim
  source $VIMRUNTIME/defaults.vim
endif

" {{{1 Mapleaders
let mapleader=' '
let maploadloeader='\\'

" {{{1 Options
set clipboard=unnamed
set completeopt=menu,menuone,noselect
set expandtab
set foldmethod=marker
set number
set relativenumber
set scrolloff=8
set shiftwidth=2
set sidescrolloff=8
set signcolumn=yes
set softtabstop=2
set tabstop=2
set colorcolumn=80

" {{{1 Common remaps
nnoremap Q @q
nnoremap <Leader>= migg=G`i
nnoremap Y y$
nnoremap <Leader>h :nohl<CR>
nnoremap <Leader><Leader> <C-^>


tnoremap <Esc> <C-\><C-n>

" {{{1 Common autocommands
" Removes all whitespace from the buffer
function! TrimWhitespace() abort
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfunction

augroup vimStartup
  autocmd!

  " When resized, resize the windows inside
  autocmd VimResized * execute "normal! \<c-w>="

  " Nest source on changes to vimrc
  autocmd BufWritePost .vimrc,init.vim,init.lua,vimrc nested source %

  autocmd BufEnter,BufNewFile .zshrc,zshrc setlocal filetype=zsh

  autocmd BufWritePre * :call TrimWhitespace()

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  "
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
augroup end

" {{{1 Grep

" AG: ag\ --nogroup\ --nocolor\ --column
" RG: rg\ --no-heading\ --vimgrep\ --smart-case
set grepprg=ag\ --nogroup\ --nocolor\ --column

" {{{1 vim-ruby
let g:ruby_path = '~/.asdf/shims'
" Use old regex engine for ruby
set re=1
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

" {{{1 Plugin loading
set rtp+=/usr/local/opt/fzf

packadd! ale
packadd! deoplete.nvim
packadd! emmet-vim
packadd! fzf.vim
packadd! markdown-preview.nvim
packadd! nvim-yarp
packadd! ultisnips
packadd! vim-bundler
packadd! vim-commentary
packadd! vim-dispatch
packadd! vim-endwise
packadd! vim-eunuch
packadd! vim-fugitive
packadd! vim-hug-neovim-rpc
packadd! vim-pandoc
packadd! vim-pandoc-syntax
packadd! vim-projectionist
packadd! vim-rails
packadd! vim-rake
packadd! vim-repeat
packadd! vim-ruby
packadd! vim-sensible
packadd! vim-snippets
packadd! vim-surround
packadd! vim-test
packadd! vim-tmux-navigator
packadd! vim-transparent
packadd! vim-unimpaired
packadd! vim-vinegar
packadd! vimwiki

" {{{1 ALE
nnoremap ]d <Plug>(ale_next)
nnoremap [d <Plug>(ale_previous)
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_fix_on_save = 1
let g:ale_linters = {
      \ 'ruby': ['reek', 'solargraph', 'brakeman', 'cspell', 'debride']
      \ }
let g:ale_fixers = {
      \ '*': ['remove_trailing_lines'],
      \ 'ruby': ['rubocop']
      \ }

" {{{1 FZF
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
nnoremap <Leader>ff :Files<CR>
nnoremap <Leader>fg :Ag<CR>
augroup FzfNess
  autocmd!
  autocmd FileType fzf tnoremap <buffer> <Esc> <Esc><Esc>
augroup END

" {{{1 vim-test
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>

" {{{1 Deoplete
" Enable deoplete when InsertEnter.
let g:deoplete#enable_at_startup = 0
augroup deopleter
  au!
  autocmd InsertEnter * call deoplete#enable()
augroup END

" {{{1 Deoplete, Endwise, Ultisnips, Tab Magic
" Must set trigger to no-op so we can handle it
let g:UltiSnipsExpandTrigger = "<nop>"
let g:UltiSnipsJumpForwardTrigger = "<Tab>"
let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"
" This is a variable that ultisnips will set when
" UltiSnips#ExpandSnippetOrJump() is called.
"   1 = It expanded or jumped
"   0 = It did nothing
let g:ulti_expand_or_jump_res = 0

" We define our own function that attemps the expand or jump, and if nothing
" happened, we return just a regular return.
function ExpandSnippetOrCarriageReturn()
   let snippet = UltiSnips#ExpandSnippetOrJump()
   if g:ulti_expand_or_jump_res > 0
      return snippet
   else
      return "\<CR>"
   endif
endfunction
" Make sure we don't allow endwise to do its own magic to CR.
let g:endwise_no_mappings = 1

" Obligitory check last character was space function
" get the column number before the current
" if col is zero, return 1 so we know it was a space
" if col is not zero, get the character before and return 1 if it's a space
function! s:check_last_char_was_space() abort
   let col = col('.') - 1
   return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" If tab is pressed:
"    and pull up menu is visible:
"      C-n to traverse list
"    else
"      if we are at the beginning of the line or the character before is a space,
"      then allow a tab (no autocomplete needed)
"      if we are not at the beginning of the line and the character before is not
"        a space, attempt a deoplete completion.
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : <SID>check_last_char_was_space() ? "\<TAB>" : deoplete#mappings#manual_complete()
inoremap <expr>   <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"| " Shift-Tab is previous entry if completion menu open.

" If CR is pressed:
"  if the pull up menu is visible
"    We attempt to expand the snippet or jump
"  otherwise
"    We CR with our own endwise call
inoremap <expr> <CR> pumvisible() ? "\<C-R>=ExpandSnippetOrCarriageReturn()\<CR>" : "\<CR>\<C-R>=EndwiseDiscretionary()\<CR>"

" {{{1 Vimwiki
let g:vimwiki_list = [{'path': '~/vimwiki', 'syntax': 'markdown', 'ext': '.md'},
      \ {'path': '~/code/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]

" {{{1 Colorscheme
let g:gruvbox_italic = 1
set background=dark
colorscheme gruvbox
