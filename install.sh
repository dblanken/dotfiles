#!/usr/bin/env zsh

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

brew bundle --file=- <<EOF
tap "homebrew/services"
tap "homebrew/cask-fonts"
tap "universal-ctags/universal-ctags"

# Unix
brew "curl"
brew "universal-ctags/universal-ctags/universal-ctags", args: ["HEAD"]
brew "git"
brew "openssl"
brew "rcm"
brew "reattach-to-user-namespace"
brew "ripgrep"
brew "tmux"
brew "vim"
brew "neovim", args: ["HEAD"]
brew "zsh"
brew "bat"
brew "cowsay"
brew "fortune"
brew "zsh-history-substring-search"

# GitHub
brew "hub"

# Programming language prerequisites and package managers
brew "libyaml" # should come after openssl
brew "coreutils"
brew "asdf"
brew "gnupg"
brew "mas"

cask "1password"
cask "aerial"
cask "alacritty"
cask "chromedriver"
cask "cyberduck"
cask "discord"
cask "docker"
cask "dropbox"
cask "firefox"
cask "homebrew/cask-fonts/font-sauce-code-pro-nerd-font"
cask "fork"
cask "google-chrome"
cask "google-drive"
cask "hammerspoon"
cask "jiggler"
cask "karabiner-elements"
cask "microsoft-auto-update"
cask "microsoft-edge"
cask "microsoft-office"
cask "microsoft-teams"
cask "osxfuse"
cask "skype-for-business"
cask "veracrypt"
cask "zoom"
mas "Microsoft Remote Desktop", id: 1295203466
mas "Paprika Recipe Manager 3", id: 1303222628
mas "Vimari", id: 1480933944
EOF

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
    local subversion="$2"
    local version
    if [ -z "$subversion" ]; then
        echo "I am changing the language from $2 to $1"
        subversion="$language"
    fi
    version="$(asdf list-all "$language" | grep "^${subversion}" | grep -v "[a-z]" | tail -1)"

    if ! asdf list "$language" | grep -Fq "$version"; then
        echo "I am not installed yet"
        asdf install "$language" "$version"
        asdf global "$language" "$version"
    fi
}

install_asdf_plugin "ruby"
install_asdf_plugin "nodejs"
install_asdf_plugin "python"
install_asdf_plugin "yarn"
install_asdf_plugin "perl"

install_asdf_language "ruby"
install_asdf_language "python"
install_asdf_language "python" "2.7.18"
bash "$HOME/.asdf/plugins/nodejs/bin/import-release-team-keyring"
install_asdf_language "nodejs"
install_asdf_language "yarn"
install_asdf_language "perl"

asdf global python `asdf list-all python | grep -v "[a-z]" | tail -1` 2.7.18

asdf reshim

yarn global add neovim
cpanm Neovim::Ext
cpanm App::cpanminus
gem update --system
number_of_cores=$(sysctl -n hw.ncpu)
bundle config --global jobs $((number_of_cores - 1))

git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim -c "PlugUpdate" -c "qa"

tic -o ~/.terminfo ~/code/dotfiles/terminfo/tmux-256color.terminfo
tic -o ~/.terminfo ~/code/dotfiles/terminfo/xterm-256color.terminfo
tic -o ~/.terminfo ~/code/dotfiles/terminfo/tmux.terminfo
tic -o ~/.terminfo ~/code/dotfiles/terminfo/alacritty.terminfo
