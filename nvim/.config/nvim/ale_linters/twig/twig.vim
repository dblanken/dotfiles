  function! TwigCallback(buffer, lines)
    let l:result = []

    for l:line in a:lines
      let l:components = split(l:line, ':')

      let l:filename = l:components[0]
      let l:line_number = l:components[1]
      let l:col_number = l:components[2]
      let l:warning = join(l:components[3:], ':')

      # if you know how to only check the current buffer, let me know.
      if l:filename != expand('%')
        continue
      endif

      call add(l:result, {
      \ 'filename': l:filename,
      \ 'text': l:warning,
      \ 'lnum': l:line_number,
      \ 'col': l:col_number,
      \ })
    endfor

    return l:result
  endfunction

  # Add twigcs to twig files
  call ale#linter#Define('twig', {
  \ 'name': 'twigcs',
  \ 'executable': 'twigcs',
  \ 'command': stdpath('data') . '/mason/bin/twigcs ' . shellescape(expand('%')) . ' --reporter emacs',
  \ 'callback': "TwigCallback"
  \ })

