if type -q nvim
  set -x VIMCONFIG $HOME/.config/nvim
  set -x VIMDATA $HOME/.local/share/nvim
  set -x MYVIMRC $VIMCONFIG/init.vim
else
  set -x VIMCONFIG $HOME/.vim
  set -x VIMDATA $HOME/.vim
  set -x MYVIMRC $HOME/.vimrc
end
