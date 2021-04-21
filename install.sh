#!/usr/bin/env zsh

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

brew bundle

env RCRC=$HOME/code/dotfiles/rcrc rcup

source ~/.zshrc

asdf plugin-add ruby
asdf plugin-add nodejs
asdf plugin-add python
asdf plugin-add yarn
asdf plugin-add perl

asdf install ruby latest
asdf install nodejs latest
asdf install python latest
asdf install yarn latest
asdf install perl latest

asdf reshim

yarn global add neovim

git clone https://github.com/k-takata/minpac.git \
    ~/.vim/pack/minpac/opt/minpac
curl -fLo ~/.vim/autoload/plugpac.vim --create-dirs \
    https://raw.githubusercontent.com/bennyyip/plugpac.vim/master/plugpac.vim

nvim -c "PackUpdate" -c "echom 'Please exit :qa when updates are complete.'"

echo "Do not forget to set up asdf globals.g
