# Shell aliases

# Editor
alias v="nvim"
alias vimrc="v ~/.vimrc"
if [[ "$EDITOR" == "nvim" || "$EDITOR" == "lvim" ]]; then
  alias v=$EDITOR
  alias vimrc="v ~/.config/nvim/init.lua"
fi
alias switch-vim=". ~/.local/bin/switch-vim"

# Configuration files
alias zshrc="v ~/.zshrc"
alias dot="cd ~/.dotfiles"
alias tmuxconf="v ~/.tmux.conf"
alias claude="$HOME/.claude/local/claude"

# Git
alias g=git
alias gca="g commit -a"
alias gcb="g checkout -b"
alias gco="g checkout"
alias gst="g st"
alias gb="g branch"
alias glog="g mylog"
alias gdiff="g diff"
alias gp="g pull --rebase"
alias gpa="g pull --rebase --all"
alias gmt="g mergetool"
alias grc="g rebase --continue"

# Rails (legacy, but keeping for compatibility)
alias be="bundle exec"
alias b="bundle"
alias r="bundle exec rails"
alias coverage="COVERAGE=true be rails test"

# Searching
alias '?'=duck
alias '??'=google
alias '???'=bing
