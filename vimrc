" vim: nowrap fdm=marker

let mapleader="\<Space>"

" {{{1 Short circuits
if has('nvim')
  if has('unix')
    if glob('~/.asdf')
      let g:python_host_prog = expand('~/.asdf/shims/python2')
      let g:python3_host_prog = expand('~/.asdf/shims/python3')
      let g:ruby_host_prog = expand('~/.asdf/shims/neovim-ruby-host')
    endif
    let g:node_host_prog = expand('~/.config/yarn/global/node_modules/neovim/bin/cli.js')
    let g:perl_host_prog = expand('/usr/local/bin/perl')
  endif
endif
" }}}

" {{{1 Settings
if !has('nvim')
  unlet! skip_defaults_vim
  source $VIMRUNTIME/defaults.vim

  " My attempt to get as close to a nvim setup for vim as I can
  " Referenced :h defaults in neovim
  set autoindent
  set autoread
  set background=dark
  set belloff=all
  set cscopeverbose
  set directory=$HOME/.local/share/vim/swap//
  set encoding=utf8
  set fileencoding=utf8
  set formatoptions+=j
  set fillchars="vert:│,fold:·"
  set history=10000
  set hlsearch
  set laststatus=2
  set listchars="tab:> ,trail:-,nbsp:+"
  set nrformats-=octal
  set sessionoptions+=unix,slash
  set sessionoptions-=options
  set shortmess+=F
  set shortmess-=S
  set sidescroll=1
  set signcolumn=yes
  set smarttab
  set tabpagemax=50
  set ttimeoutlen=50
  set viewoptions+=unix,slash
  set undodir=$HOME/.local/share/vim/undo
  set wildmenu
  set wildoptions=tagfile

  let g:loaded_getscriptPlugin = 1
  let g:loaded_gzip = 1
  let g:loaded_logiPat = 1
  let g:loaded_rrhelper = 1
  let g:loaded_tarPlugin = 1
  let g:loaded_vimballPlugin = 1
  let g:loaded_zipPlugin = 1
endif
set clipboard=unnamedplus,unnamed
set colorcolumn=80
set expandtab
set hidden
set nobackup
set noerrorbells
set noswapfile
set number
set relativenumber
set shiftwidth=2
set smartcase
set softtabstop=2
set undofile
set formatoptions-=cro
set nowrap
set incsearch
set updatetime=50
" }}}

" {{{1 Plugins
function! PackInit() abort
  packadd minpac

  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  call minpac#add('tpope/vim-bundler')
  call minpac#add('tpope/vim-commentary')
  call minpac#add('tpope/vim-dispatch')
  call minpac#add('tpope/vim-eunuch')
  call minpac#add('tpope/vim-fugitive')
  call minpac#add('tpope/vim-projectionist')
  call minpac#add('tpope/vim-markdown')
  call minpac#add('tpope/vim-obsession')
  call minpac#add('tpope/vim-ragtag')
  call minpac#add('tpope/vim-rails')
  call minpac#add('tpope/vim-rake')
  call minpac#add('tpope/vim-repeat')
  call minpac#add('tpope/vim-surround')
  call minpac#add('dblanken/vim-unimpaired')
  call minpac#add('tpope/vim-vinegar')
  call minpac#add('vim-ruby/vim-ruby')
  call minpac#add('christoomey/vim-tmux-navigator')
  call minpac#add('AndrewRadev/splitjoin.vim')
  call minpac#add('vim-test/vim-test')
  call minpac#add('junegunn/fzf.vim')
  call minpac#add('gruvbox-community/gruvbox', {'type': 'opt'})
  call minpac#add('wincent/loupe')
  call minpac#add('wincent/terminus')
  call minpac#add('mattn/emmet-vim')
  call minpac#add('dpelle/vim-LanguageTool', {'type': 'opt'})
  call minpac#add('vim-pandoc/vim-pandoc', {'type': 'opt'})
  call minpac#add('vim-pandoc/vim-pandoc-syntax', {'type': 'opt'})
  call minpac#add('joshdick/onedark.vim', {'type': 'opt'})
  call minpac#add('chriskempson/base16-vim', {'type': 'opt'})
  call minpac#add('itchyny/lightline.vim')
  call minpac#add('mike-hearn/base16-vim-lightline')
  call minpac#add('vuciv/vim-bujo')
  call minpac#add('unblevable/quick-scope')
  call minpac#add('honza/vim-snippets')
  call minpac#add('neoclide/coc.nvim', {'branch': 'release'})
  call minpac#add('glacambre/firenvim', { 'type': 'opt', 'do': 'packadd firenvim | call firenvim#install(0)'})
endfunction

command! PackUpdate source $MYVIMRC | call PackInit() | call minpac#update()
command! PackClean  source $MYVIMRC | call PackInit() | call minpac#clean()
command! PackStatus packadd minpac | call minpac#status()
command! PackInstall PackUpdate

set rtp+=/usr/local/opt/fzf
if exists('g:started_by_firenvim')
  packadd firenvim
  let g:firenvim_config = {
        \ 'globalSettings': {
        \ 'alt': 'all',
        \  },
        \ 'localSettings': {
        \ '.*': {
        \ 'cmdline': 'neovim',
        \ 'priority': 0,
        \ 'selector': 'textarea',
        \ 'takeover': 'always',
        \ },
        \ }
        \ }
endif
" }}}

" {{{1 Coc.Nvim
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

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap<tab>' to make sure tab is not mapped by
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

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

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
" Note coc#float#scroll works on neovim >= 0.4.3 or vim >= 8.2.0750
nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

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
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
" }}}

" " {{{1 Deoplete/UltiSnips
" let g:deoplete#enable_at_startup = 0

" " Set completeopt to have a better completion experience
" set completeopt=menuone,noinsert,noselect
" set signcolumn=yes

" " Avoid showing message extra message when using completion
" set shortmess+=c
" autocmd InsertEnter * call deoplete#enable()

" let g:UltiSnipsExpandTrigger = "<nop>"
" let g:UltiSnipsJumpForwardTrigger = "<Tab>"
" let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"
" let g:ulti_expand_or_jump_res = 0
" function ExpandSnippetOrCarriageReturn()
"     let snippet = UltiSnips#ExpandSnippetOrJump()
"     if g:ulti_expand_or_jump_res > 0
"         return snippet
"     else
"         return "\<CR>"
"     endif
" endfunction
" let g:endwise_no_mappings = 1
" let g:AutoPairsMapCR = 0

" function! s:check_last_char_was_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~ '\s'
" endfunction

" inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : <SID>check_last_char_was_space() ? "\<TAB>" : deoplete#mappings#manual_complete()
" inoremap <expr>   <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" inoremap <expr> <CR> pumvisible() ? "\<C-R>=ExpandSnippetOrCarriageReturn()\<CR>" : "\<CR>\<C-R>=EndwiseDiscretionary()\<CR><C-R>=AutoPairsReturn()\<CR>"
" " }}}

" {{{1 FZF config
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS='--reverse'
nnoremap <C-p> :Files<CR>

augroup fzf_overrides
  autocmd!
  " Allow Esc to exit fzf
  autocmd FileType fzf tnoremap <buffer> <Esc> <Esc><Esc>
augroup END
" }}}

" {{{1 Netrw config
let g:netrw_browse_split = 2
let g:netrw_banner = 0
let g:netrw_winsize = 25
" }}}

" {{{1 vim-test config
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
let test#strategy = 'dispatch'
" }}}

" {{{1 vim-rails config
" This lets me create a test file properly
let g:rails_projections = {
      \ "test/models/*_test.rb": {"command": "modeltest",
      \   "template":
      \     ["require \"test_helper\"",
      \      "",
      \      "class {camelcase|capitalize|colons}Test < ActiveSupport::TestCase",
      \      "end"]
      \   }
      \ }
" }}}

" {{{1 vim-fugitive
nnoremap <Leader>gd :Gvdiffsplit!<CR>
nnoremap gdh :diffget //2<CR>
nnoremap gdl :diffget //3<CR>
" }}}

" {{{1 Bujo
function! SetupBujoBufferMappings() abort
  nmap <buffer> <C-S> <Plug>BujoAddnormal
  imap <buffer> <C-S> <Plug>BujoAddinsert

  nmap <buffer> <C-Q> <Plug>BujoChecknormal
  imap <buffer> <C-Q> <Plug>BujoCheckinsert
endfunction

augroup DblankenBujo
  autocmd!
  autocmd BufEnter todo.md call SetupBujoBufferMappings()
augroup END
" }}}

" " {{{1 ALE
" nmap <silent> [W <Plug>(ale_first)
" nmap <silent> [w <Plug>(ale_previous)
" nmap <silent> ]w <Plug>(ale_next)
" nmap <silent> ]W <Plug>(ale_last)

" let g:ale_linters = {
"       \ 'ruby': ['rubocop', 'reek', 'brakeman', 'solargraph'],
"       \ 'javascript': ['tsserver', 'eslint'],
"       \ 'vim': ['vimls']
"       \ }

" let g:ale_fixers = {
"       \ '*': [ 'trim_whitespace', 'remove_trailing_lines'],
"       \ 'ruby': [ 'rubocop', 'trim_whitespace', 'remove_trailing_lines'],
"       \ 'javascript': [ 'eslint', 'trim_whitespace', 'remove_trailing_lines' ],
"       \ 'vim': ['remove_trailing_lines', 'trim_whitespace']
"       \ }

" " Always show sign column
" let g:ale_sign_column_always = 1
" " Fix on save
" let g:ale_fix_on_save = 1
" " Set to show which linter says there is an issue
" let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" " Allow go to definition
" nmap <silent> gd <Plug>(ale_go_to_definition)
" nmap <silent> gr <Plug>(ale_find_references)

" " Allow hovering in balloons
" let g:ale_set_balloons = 1

" let g:ale_javascript_tsserver_use_global = 1
" let g:ale_vim_vimls_use_global = 1

" let g:ale_sign_error='✖'
" let g:ale_sign_warning='⚠'
" let g:ale_sign_info='ℹ'
" let g:ale_sign_hint='➤'

" " Becuase we're using ALE with StandardRb, we need vim-ruby to change its
" " indentation style.
" " https://github.com/testdouble/standard/wiki/IDE:-vim
" let g:ruby_indent_assignment_style = 'variable'
" " Same for hanging elements
" let g:ruby_indent_hanging_elements = 0
" " Disable lsp server on ALE only
" " let g:ale_disable_lsp = 1

" " Try ALE's completion from the LSP
" " let g:ale_completion_enabled = 1

" if has('nvim')
"   " Allow floating windows in ale
"   let g:ale_floating_window = 1
" end
" " }}}

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

" Delete what you have highlighted to the void register and paste what you
" wanted.  It does not replace what you've copied previously.  Actual delete.
vnoremap <Leader>p "_dP
" }}}

" {{{1 Autogroups
function! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfunction

augroup misc
  autocmd!

  " This is already in the default.vim, so only for nvim here
  if has('nvim')
    " On opening a file, jump to the last known cursor position (see :h line())
    autocmd BufReadPost *
          \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' |
          \   exe "normal! g`\"" |
          \ endif
  endif

  " When resized, resize the windows inside
  autocmd VimResized * execute "normal! \<c-w>="

  " Nest source on changes to vimrc
  autocmd BufWritePost .vimrc,init.vim,vimrc nested source %

  autocmd BufEnter,BufNewFile .zshrc,zshrc setlocal filetype=zsh

  autocmd BufWritePre * :call TrimWhitespace()
augroup end

augroup ruby
  autocmd!
  " Make ? part of a keyword
  autocmd FileType ruby,eruby,yaml setlocal iskeyword+=?
augroup end

if has('nvim')
  augroup TextYankPoster
    autocmd!
    if exists('##TextYankPost')
      autocmd TextYankPost * silent! lua vim.highlight.on_yank {"IncSearch", 200}
    endif
  augroup END
endif
" }}}

" {{{1 rg/grep
if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep\ --smart-case
endif
" }}}

" {{{1 Colorscheme
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection='0'
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
colorscheme gruvbox
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
  let g:current_theme = 'base16_'.trim(system("$HOME/bin/get_theme.sh"))
endif

augroup MyColorSchemeOverrides
  au!
  au ColorScheme * highlight Comment cterm=italic gui=italic
augroup END

" {{{2 Lighline
function! LightlineFugitive() abort
  if exists('*FugitiveHead')
    let branch = FugitiveHead()
    return branch !=# '' ? ''.branch : ''
  endif
  return ''
endfunction

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'fugitive', 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [
      \              [ 'lineinfo' ],
      \              [ 'percent'  ],
      \              [ 'lsp', 'fileformat', 'fileencoding', 'filetype' ]
      \   ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightlineFugitive',
      \   'filename': 'FilenameForLightLine',
      \   'lsp': 'LspStatus',
      \   'cocstatus': 'coc#status'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

if g:current_theme != "base16_default"
  let g:lightline.colorscheme = g:current_theme
endif

function! FilenameForLightLine()
  return expand('%')
endfunction
" }}}
" }}}

" {{{1 Writing
function! Writer() abort
  setlocal spell spelllang=en_us
  setlocal formatoptions=t1
  setlocal textwidth=80
  setlocal noautoindent
  setlocal tabstop=5
  setlocal shiftwidth=5
  setlocal expandtab
  setlocal thesaurus=~/.thesaurus/thesaurus.txt
  packadd vim-LanguageTool
  packadd vim-pandoc-syntax
  packadd vim-pandoc
  runtime ftplugin/pandoc.vim
endfunction
command! WR call Writer()
" Since I use other java versions, point it to the adoptopenjdk8 java binary
let g:languagetool_jar='/usr/local/Cellar/languagetool/5.0/libexec/languagetool-commandline.jar'
let g:languagetool_cmd='/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home/bin/java -jar ' . g:languagetool_jar

" let g:pandoc#command#latex_engine="mactex"
let g:pandoc#modules#enabled = [
      \'yaml',
      \'completion',
      \'command',
      \'formatting',
      \'indent',
      \'menu',
      \'metadata',
      \'keyboard' ,
      \'toc',
      \'spell',
      \'hypertext']
" }}}
