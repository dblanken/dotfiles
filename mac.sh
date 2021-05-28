#!/usr/bin/env zsh

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

brew bundle --file=- <<EOF
tap "homebrew/services"
tap "homebrew/cask-fonts"
tap "universal-ctags/universal-ctags"

# Unix
brew "bash"
brew "bash-completion@2"
brew "bat"
brew "bat"
brew "curl"
brew "git"
brew "grep"
brew "htop
brew "jq"
brew "less"
brew "lesspipe"
brew "lynx"
brew "nmap"
brew "openssl"
brew "reattach-to-user-namespace"
brew "ripgrep"
brew "socat"
brew "tmux"
brew "tree"
brew "universal-ctags/universal-ctags/universal-ctags", args: ["HEAD"]
brew "vim"
brew "watch"
brew "wget"
brew "yq"
brew "zsh"
brew "zsh-history-substring-search"

# GitHub
brew "gh"
brew "hub"

# Programming language prerequisites and package managers
brew "asdf"
brew "coreutils"
brew "fzf"
brew "gnupg"
brew "libyaml" # should come after openssl
brew "mas"
brew "pandoc"
brew "shellcheck"
brew "sqlite"
brew "v8"
brew "v8@3.15"

# Fun
brew "asciiquarium"
brew "dopewars"
brew "fortune"
brew "lolcat"
brew "mpv"
brew "rogue"
brew "weechat"

cask "1password"
cask "aerial"
cask "amazon-music"
cask "chromedriver"
cask "cyberduck"
cask "discord"
cask "docker"
cask "dropbox"
cask "firefox"
cask "fork"
cask "google-chrome"
cask "google-drive"
cask "hammerspoon"
cask "homebrew/cask-fonts/font-sauce-code-pro-nerd-font"
cask "homebrew/cask-fonts/font-ubuntu-mono-nerd-font"
cask "jiggler"
cask "karabiner-elements"
cask "keepassxc"
cask "microsoft-auto-update"
cask "microsoft-edge"
cask "microsoft-office"
cask "microsoft-teams"
cask "minecraft"
cask "mysqlworkbench"
cask "osxfuse"
cask "skype-for-business"
cask "veracrypt"
cask "xquartz"
cask "zoom"

mas "Microsoft Remote Desktop", id: 1295203466
mas "Paprika Recipe Manager 3", id: 1303222628
EOF

./setup

source ~/.bash_profile

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

gem update --system
number_of_cores=$(sysctl -n hw.ncpu)
bundle config --global jobs $((number_of_cores - 1))

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

tic -o ~/.terminfo ~/code/dotfiles/terminfo/tmux-256color.terminfo
tic -o ~/.terminfo ~/code/dotfiles/terminfo/xterm-256color.terminfo
tic -o ~/.terminfo ~/code/dotfiles/terminfo/tmux.terminfo
tic -o ~/.terminfo ~/code/dotfiles/terminfo/alacritty.terminfo
