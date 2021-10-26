" {{{1 My settings
let g:my_colorscheme = 'dracula'

" {{{1 Plugins
set packpath^=~/.local/share/vim
function! PackInit() abort
  packadd minpac

  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  call minpac#add('AndrewRadev/sideways.vim')                           " Argument swapping
  call minpac#add('AndrewRadev/splitjoin.vim')                          " Splitting/Joining blocks
  call minpac#add('SirVer/ultisnips')                                   " Snippet manager
  call minpac#add('bkad/CamelCaseMotion')                               " Traverse CamelCaseWords (<Leader>w)
  call minpac#add('christoomey/vim-tmux-navigator')                     " Tmux integration
  call minpac#add('dense-analysis/ale')                                 " linting
  call minpac#add('dracula/vim', {'name': 'dracula' })                  " For halloween
  call minpac#add('godlygeek/tabular')                                  " Easy tabbed formatting
  call minpac#add('honza/vim-snippets')                                 " Snippet repository
  call minpac#add('jiangmiao/auto-pairs')                               " { } pairing
  call minpac#add('junegunn/fzf')                                       " Real FZF for vim plugin
  call minpac#add('junegunn/fzf.vim')                                   " Fuzzy finding
  call minpac#add('joshdick/onedark.vim', {'name': 'onedark'})          " Good color scheme
  call minpac#add('kana/vim-textobj-user')                              " Needed for rubyblock
  call minpac#add('mattn/emmet-vim')                                    " Easy HTML
  call minpac#add('morhetz/gruvbox')                                    " The best colorscheme
  call minpac#add('nelstrom/vim-textobj-rubyblock')                     " ir and ar
  call minpac#add('tpope/vim-commentary')                               " For commenting
  call minpac#add('tpope/vim-dispatch')                                 " Async test running
  " call minpac#add('tpope/vim-endwise')                                  " Endings
  call minpac#add('tpope/vim-eunuch')                                   " Shell file operations
  call minpac#add('tpope/vim-fugitive')                                 " Git
  call minpac#add('tpope/vim-projectionist')                            " Easy project traversal
  call minpac#add('tpope/vim-rails')                                    " Rails
  call minpac#add('tpope/vim-rake')                                     " Rake
  call minpac#add('tpope/vim-repeat')                                   " Make plugins repeatable
  call minpac#add('tpope/vim-sensible')                                 " I prefer these defaults
  call minpac#add('tpope/vim-sleuth')                                   " Don't worry about tabs/spacing
  call minpac#add('tpope/vim-surround')                                 " Surround mappings
  call minpac#add('tpope/vim-unimpaired')                               " [/] mappings
  call minpac#add('tpope/vim-vinegar')                                  " File tree navigation
  call minpac#add('vim-ruby/vim-ruby')                                  " Ruby
  call minpac#add('vim-test/vim-test')                                  " Testing
  call minpac#add('digitaltoad/vim-pug')                                " Jade/Pug syntax
  call minpac#add('neoclide/coc.nvim', {'branch': 'release'})           " LSP Goodness
endfunction

" Define user commands for updating/cleaning the plugins.
" Each of them calls PackInit() to load minpac and register
" the information of plugins, then performs the task.
command! PackUpdate call PackInit() | call minpac#update()
command! PackClean  call PackInit() | call minpac#clean()
command! PackStatus packadd minpac | call minpac#status()

" {{{1 Settings
let mapleader="\<Space>"

if !has('nvim')
  unlet! skip_defaults_vim
  source $VIMRUNTIME/defaults.vim
else
  let g:loaded_sensible = 1
end

set autoindent
set autoread
set background=dark
set belloff=all
set clipboard=unnamedplus,unnamed
set colorcolumn=+1
set complete+=kspell
set cscopeverbose
set diffopt+=vertical
set directory=$HOME/.local/share/vim/swap//
set encoding=utf8
set expandtab
set fileencoding=utf8
set fillchars="vert:│,fold:·"
set formatoptions+=j
set formatoptions-=cro
set guioptions-=e
set hidden
set history=10000
set hlsearch
set incsearch
set laststatus=2
set listchars="tab:> ,trail:-,nbsp:+"
set nobackup
set noerrorbells
set noswapfile
set nowrap
set nrformats-=octal
set number
set numberwidth=5
set relativenumber
set sessionoptions+=unix,slash
set sessionoptions-=options
set shiftwidth=2
set shortmess+=F
set shortmess-=S
set showtabline=2
set sidescroll=1
set signcolumn=yes
set smartcase
set smarttab
set softtabstop=2
set splitbelow
set splitright
set tabpagemax=50
set textwidth=80
set ttimeoutlen=50
set undodir=$HOME/.local/share/vim/undo//
set undofile
set updatetime=50
set viewoptions+=unix,slash
set wildmenu
set wildoptions=tagfile

set foldlevel=1
set foldmethod=syntax

let g:loaded_getscriptPlugin = 1
let g:loaded_gzip = 1
let g:loaded_logiPat = 1
let g:loaded_rrhelper = 1
let g:loaded_tarPlugin = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zipPlugin = 1

" {{{1 autogroups
augroup misc
  autocmd!

  " When resized, resize the windows inside
  autocmd VimResized * execute "normal! \<c-w>="

  " Nest source on changes to vimrc
  autocmd BufWritePost .vimrc,init.vim,vimrc nested source %

  autocmd BufEnter,BufNewFile .zshrc,zshrc setlocal filetype=zsh

  autocmd BufWritePre * :call whitespace#trim()

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
augroup end

augroup ruby
  autocmd!
  " Make ? part of a keyword
  autocmd FileType ruby,eruby,yaml setlocal iskeyword+=?
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
  autocmd FileType help setlocal ai formatoptions+=2n
  autocmd FileType ruby setlocal comments=:#\ tw=78
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd FileType liquid,markdown,text,txt setlocal tw=78 linebreak keywordprg=dict spell
  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
augroup END

" {{{1 Mappings
nnoremap Q @q
nnoremap <Leader>= migg=G`i
nnoremap Y y$
nnoremap <Leader>g :grep!<Space>
if exists(':tnoremap')
  tnoremap <Esc> <C-\><C-n>
endif

nnoremap <Leader>s :s/\(<C-r>=expand("<cword>")<CR>\)/

command! Vimrc vsp ~/.vimrc

nnoremap <Leader>\ :vsplit<CR>
nnoremap <Leader>- :split<CR>

nnoremap <Leader>h :nohl<CR>
nnoremap <Leader><Leader> <C-^>

" Delete what you have highlighted to the void register and paste what you
" wanted.  It does not replace what you've copied previously.  Actual delete.
vnoremap <Leader>p "_dP

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<Tab>"
  else
    return "\<C-p>"
  endif
endfunction
inoremap <Tab> <C-r>=InsertTabWrapper()<CR>
inoremap <S-Tab> <C-n>

" Switch between the last two files
nnoremap <Leader><Leader> <C-^>

" Next, center in screen, open folds
nnoremap n nzzzv
nnoremap N Nzzzv
" Mark z, J, go back to mark z
nnoremap J mzJ`z

" Undo breakpoints
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u
inoremap = =<c-g>u
inoremap [ [<c-g>u
inoremap ] ]<c-g>u
inoremap { {<c-g>u
inoremap } }<c-g>u

" Add counted jumps to jump list
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

" Visual moving of lines
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" {{{1 netrw config
let g:netrw_browse_split = 2
let g:netrw_banner = 0
let g:netrw_winsize = 25

" {{{1 rg/ag/grep
if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep\ --smart-case

  if !exists(":Rg")
    command -nargs=+ -complete=file -bar Rg silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Rg<SPACE>
  endif

  " Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
elseif executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in fzf for listing files. Lightning fast and respects .gitignore
  let $FZF_DEFAULT_COMMAND = 'ag --literal --files-with-matches --nocolor --hidden -g ""'

  if !exists(":Ag")
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
  endif
endif

" {{{1 spelling
if has('spell')
  setglobal spelllang=en_us
  setglobal spellfile=~/.vim/spell/en.utf-8.add
  let g:spellfile_URL = 'http://ftp.vim.org/vim/runtime/spell'
  autocmd FileType gitcommit setlocal spell
  autocmd FileType help if &buftype ==# 'help' | setlocal nospell | endif
endif

" {{{1 Ultisnips
let g:UltiSnipsExpandTrigger = '<c-j>'

" {{{1 Vim-Test
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
let g:test#strategy = 'dispatch'

" {{{1 ALE
nmap <silent> ]d         <Plug>(ale_next_wrap)
nmap <silent> [d         <Plug>(ale_previous_wrap)
" nmap <silent> gd         <Plug>(ale_go_to_definition)
" nmap <silent> gr         <Plug>(ale_find_references)
" nmap <silent> K          <Plug>(ale_hover)
nmap <silent> <leader>e  <Plug>(ale_detail)
" nmap <silent> <leader>rn <Plug>(ale_rename)
nmap <silent> <leader>f  <Plug>(ale_fix)

" Set to show which linter says there is an issue
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" Custom images for issues
let g:ale_sign_error = ' '
let g:ale_sign_info = ' '
let g:ale_sign_warning = ' '
let g:ale_echo_msg_error_str = g:ale_sign_error
let g:ale_echo_msg_info_str = g:ale_sign_info
let g:ale_echo_msg_warning_str = g:ale_sign_warning
let g:ale_echo_msg_format = '[%linter%] %severity% %code: %%s'
let g:ale_fixers = {
      \   'ruby': ['standardrb', 'remove_trailing_lines', 'trim_whitespace'],
      \   'json': ['jq'],
      \   'javascript': ['eslint']
      \ }
let g:ale_linters = {'ruby': ['standardrb', 'debride', 'brakeman', 'rails_best_practices', 'reek', 'solargraph']}
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰']
let g:ale_fix_on_save = 1
let g:ale_floating_preview = 1
let g:ale_cursor_detail = 1
" let g:ale_completion_enabled = 1
" set omnifunc=ale#completion#OmniFunc
let g:ale_disable_lsp = 1
let g:ale_completion_symbols = {
      \ 'text': '',
      \ 'method': '',
      \ 'function': '',
      \ 'constructor': '',
      \ 'field': '',
      \ 'variable': '',
      \ 'class': '',
      \ 'interface': '',
      \ 'module': '',
      \ 'property': '',
      \ 'unit': 'unit',
      \ 'value': 'val',
      \ 'enum': '',
      \ 'keyword': 'keyword',
      \ 'snippet': '',
      \ 'color': 'color',
      \ 'file': '',
      \ 'reference': 'ref',
      \ 'folder': '',
      \ 'enum member': '',
      \ 'constant': '',
      \ 'struct': '',
      \ 'event': 'event',
      \ 'operator': '',
      \ 'type_parameter': 'type param',
      \ '<default>': 'v'
      \ }

augroup AleOmni
  au!
  autocmd FileType ruby setlocal omnifunc=ale#completion#OmniFunc
  autocmd VimEnter *
        \ set updatetime=1000 |
        \ let g:ale_lint_on_text_changed = 0
  autocmd CursorHold * call ale#Queue(0)
  autocmd CursorHoldI * call ale#Queue(0)
  autocmd InsertEnter * call ale#Queue(0)
  autocmd InsertLeave * call ale#Queue(0)
augroup END

" {{{1 Coc.nvim
" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[d` and `]d` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>ca  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>ce  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>cc  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>co  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>cs  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>cj  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>ck  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>cp  :<C-u>CocListResume<CR>

let g:coc_global_extensions = [
      \ 'coc-yank',
      \ 'coc-yaml',
      \ 'coc-xml',
      \ 'coc-vimlsp',
      \ 'coc-tsserver',
      \ 'coc-sumneko-lua',
      \ 'coc-sql',
      \ 'coc-solargraph',
      \ 'coc-snippets',
      \ 'coc-sh',
      \ 'coc-pairs',
      \ 'coc-markdownlint',
      \ 'coc-lists',
      \ 'coc-json',
      \ 'coc-html',
      \ 'coc-html-css-support',
      \ 'coc-highlight',
      \ 'coc-git',
      \ 'coc-emmet',
      \ 'coc-css'
      \ ]
" {{{1 Misc
" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" For some reason, CreateMotionMappings is not avaialble on initial startup, so
" it must wait until VimEnter
augroup CamelCaseMotions
  au!
  autocmd VimEnter call camelcasemotion#CreateMotionMappings('<leader>')
augroup END

nnoremap <silent> <C-p> :Files<CR>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

let g:rubycomplete_rails = 1

iabbrev inc include
iabbrev req require
iabbrev eac each

" {{{1 Status line
set statusline=%<%f\ %h%m%r%{FugitiveStatusline()}%=%-14.(%l,%c%V%)\ %P

" {{{1 Colorscheme
if !exists('g:my_colorscheme')
  let g:my_colorscheme = 'desert'
endif

if g:my_colorscheme == 'gruvbox'
  packadd! gruvbox
  let g:gruvbox_italic = 1
  let g:gruvbox_transparent_bg = 1
  let g:gruvbox_contrast_dark = 'hard'
  let g:gruvbox_italicize_strings = 1
elseif g:my_colorscheme == 'dracula'
  packadd! dracula
  let g:dracula_bold = 1
  let g:dracula_italic = 1
  let g:dracula_underline = 1
  let g:dracula_undercurl = 1
elseif g:my_colorscheme == 'onedark'
  set background=dark
  packadd! onedark
  let g:onedark_hide_endofbuffer = 1
  let g:onedark_terminal_italics = 1
endif

call transparency#enable()
execute "colorscheme " . g:my_colorscheme

" {{{1 Modeline
" vim: nowrap fdm=marker
