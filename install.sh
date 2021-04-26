#!/usr/bin/env zsh

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

brew bundle

env RCRC=$HOME/code/dotfiles/rcrc rcup

source ~/.zshrc

install_asdf_plugin() {
    local name="$1"
    local url="$2"

    if ! asdf plugin-list | grep -Fq "$name"; then
        asdf plugin-add "$name" "$url"
    else
        asdf plugin-update "$name"
    fi
}

install_asdf_language() {
    local language="$1"
    local version
    verison="$(asdf list-all "$language" | grep -v "[a-z]" | tail -1)"

    if ! asdf list "$language" | grep -Fq "$version"; then
        asdf install "$language" "$version"
        asdf global "$language" "$version"
    fi
}

install_asdf_plugin "ruby"
install_asdf_plugin "python"
install_asdf_plugin "yarn"
install_asdf_plugin "perl"
install_asdf_plugin "nodejs"

install_asdf_language "ruby"
install_asdf_language "python"
install_asdf_language "yarn"
install_asdf_language "perl"
bash "$HOME/.asdf/plugins/nodejs/bin/import-release-team-keyring"
install_asdf_language "nodejs"

asdf reshim

yarn global add neovim
gem update --system
number_of_cores=$(sysctl -n hw.ncpu)
bundle config --global jobs $((number_of_cores - 1))

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim -c "PlugUpdate" -c "qa"
