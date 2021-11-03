Plug 'mattn/emmet-vim'

let g:user_emmet_mode='a'
let g:user_emmet_complete_tag = 0
let g:user_emmet_install_global = 0

augroup EmmetOverrides
  autocmd!
  autocmd FileType html,css,scss,eruby,typescriptreact,vue,javascript,markdown.mdx imap <silent><buffer><expr><tab> <sid>expand_html_tab()
  autocmd FileType html,css,scss,eruby,typescriptreact,vue,javascript,markdown.mdx EmmetInstall
augroup END

" Taken from https://github.com/mhartington/dotfiles/blob/7560986378753e0c047d940452cb03a3b6439b11/config/nvim/bac_init.vim
" Remapping <C-y>, just doesn't cut it.
" Will allow tab expansion if the text entered is an emmet recognized starter
function! s:expand_html_tab()
  " try to determine if we're within quotes or tags.
  " if so, assume we're in an emmet fill area.
  let line = getline('.')
  if col('.') < len(line)
    let line = matchstr(line, '[">][^<"]*\%'.col('.').'c[^>"]*[<"]')
    if len(line) >= 2
      return "\<C-n>"
    endif
  endif
  " expand anything emmet thinks is expandable.
  if emmet#isExpandable()
    return emmet#expandAbbrIntelligent("\<tab>")
  endif
  " return a regular tab character
  return "\<tab>"
endfunction
"}}}
