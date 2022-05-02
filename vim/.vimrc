unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

let mapleader=' '
let maploadloeader='\\'

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
" set termguicolors

nnoremap Q @q
nnoremap <Leader>= migg=G`i
nnoremap Y y$
nnoremap <Leader>h :nohl<CR>
nnoremap <Leader><Leader> <C-^>

tnoremap <Esc> <C-\><C-n>

nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u
inoremap = =<c-g>u
inoremap [ [<c-g>u
inoremap ] ]<c-g>u
inoremap { {<c-g>u
inoremap } }<c-g>u

nnoremap <expr> k (v:count > 5 ? "m\'" . v:count : "") . "k"
nnoremap <expr> j (v:count > 5 ? "m\'" . v:count : "") . "j"

vnoremap < <gv
vnoremap > >gv

" vnoremap y myy`y
" vnoremap Y myY`y

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

inoremap ;; <Esc>A;<Esc>
inoremap ,, <Esc>A,<Esc>

" Removes all whitespace from the buffer
function! TrimWhitespace() abort
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfunction

augroup misc
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

augroup dblanken_filetypes
  autocmd FileType * setlocal nolinebreak
  autocmd FileType xml,xsd,xslt,javascript setlocal ts=2
  autocmd FileType mail,gitcommit setlocal tw=72 spell
  autocmd FileType sh,zsh,csh,tcsh setlocal fo-=t|
        \ inoremap <silent> <buffer> <C-X>! #!/bin/<C-R>=&ft<CR>
  autocmd FileType perl,python,ruby,tcl
        \ inoremap <silent> <buffer> <C-X>! #!/usr/bin/env<Space><C-R>=&ft<CR>
  autocmd FileType javascript
        \ inoremap <silent> <buffer> <C-X>! #!/usr/bin/env<Space>node
  autocmd FileType help setlocal ai formatoptions+=2n nospell
  autocmd FileType ruby setlocal comments=:#\ tw=78
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd FileType liquid,markdown,text,txt setlocal tw=78 linebreak keywordprg=dict spell
  autocmd BufRead,BufNewFile */.zsh/* set ft=zsh
augroup END

" AG: ag --nogroup --nocolor
set grepprg=rg\ --no-heading\ --vimgrep\ --smart-case

packadd! vim-sensible
packadd! vim-commentary
packadd! vim-eunuch
packadd! vim-fugitive
packadd! vim-dispatch
packadd! vim-projectionist
packadd! vim-rails
packadd! vim-rake
packadd! vim-repeat
packadd! vim-surround
packadd! vim-tmux-navigator
packadd! vim-test
packadd! vim-unimpaired
packadd! vimwiki
packadd! vim-pandoc
packadd! vim-pandoc-syntax
packadd! ale
packadd! deoplete.nvim
packadd! nvim-yarp
packadd! vim-hug-neovim-rpc
packadd! ultisnips
packadd! vim-snippets
packadd! base16-vim
packadd! vim-endwise
packadd! vim-transparent

augroup deopleter
  autocmd!
  autocmd InsertEnter * call deoplete#enable()
augroup END

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

nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
let test#strategy = 'dispatch'

nnoremap ]d <Plug>(ale_next_wrap)
nnoremap [d <Plug>(ale_previous_wrap)

let g:rails_projections = {
      \ "test/models/*_test.rb": {
      \   "command": "modeltest",
      \   "template": [
      \     "require 'test_helper'",
      \     "",
      \     "class {camelcase|capitalize|colons}Test < ActiveSupport::TestCase",
      \     "",
      \     "end"
      \   ],
      \   "alternate": "app/models/{}.rb"
      \   }
      \ }

let g:vimwiki_list = [
      \   { 'path': '~/code/vimwiki', 'syntax': 'markdown', 'ext': '.md' },
      \   { 'path': '~/vimwiki', 'syntax': 'markdown', 'ext': '.md' }
      \ ]

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif
