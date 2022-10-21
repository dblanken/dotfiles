if !has('nvim')
  unlet! skip_defaults_vim
  source $VIMRUNTIME/defaults.vim
endif

if has('nvim')
  let g:vim_location=expand('~/.config/nvim')
  let g:vim_name='nvim'
else
  let g:vim_location=expand('~/.vim')
  let g:vim_name='vim'
endif
let g:vimplug_exists=expand(vim_location . '/autoload/plug.vim')
if has('win32')&&!has('win64')
  let g:curl_exists=expand('C:\Windows\Sysnative\curl.exe')
else
  let g:curl_exists=expand('curl')
endif

if !filereadable(g:vimplug_exists)
  if !executable(g:curl_exists)
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent exec "!"curl_exists" -fLo " . shellescape(g:vimplug_exists) . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif
