Plug 'dense-analysis/ale'

function! AleSetup() abort
  nmap <silent> ]d         <Plug>(ale_next_wrap)
  nmap <silent> [d         <Plug>(ale_previous_wrap)
  nmap <silent> gd         <Plug>(ale_go_to_definition)
  nmap <silent> gr         <Plug>(ale_find_references)
  nmap <silent> K          <Plug>(ale_hover)
  nmap <silent> <leader>e  <Plug>(ale_detail)
  nmap <silent> <leader>rn <Plug>(ale_rename)
  nmap <silent> <leader>f  <Plug>(ale_fix)

  " Set to show which linter says there is an issue
  let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
  " Custom images for issues
  let g:ale_sign_error = ' '
  let g:ale_sign_info = ' '
  let g:ale_sign_warning = ' '
  let g:ale_echo_msg_format = '[%linter%] %severity% %code: %%s'
  let g:ale_echo_msg_error_str = g:ale_sign_error
  let g:ale_echo_msg_info_str = g:ale_sign_info
  let g:ale_echo_msg_warning_str = g:ale_sign_warning

  if exists('g:lsp_plugin') && g:lsp_plugin != 'ale'
    let g:ale_disable_lsp = 1
    let g:ale_linters_ignore = { 'ruby': ['solargraph'] }
  endif
  let g:ale_fixers = {'ruby': ['standardrb', 'remove_trailing_lines', 'trim_whitespace']}
  let g:ale_linters = {'ruby': ['standardrb', 'debride', 'brakeman', 'rails_best_practices', 'reek', 'solargraph']}
  let g:ale_fix_on_save = 1
  let g:ale_floating_preview = 1
  let g:ale_hover_to_floating_window = 1
  let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰']
  let g:ale_cursor_detail = 1
  let g:ale_hover_cursor = 1
  let g:ale_set_balloons = 1
  let g:ale_completion_enabled = 1
  set omnifunc=ale#completion#OmniFunc
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
endfunction

augroup SetupAle
  autocmd!
  autocmd User PlugLoaded call AleSetup()
augroup END
