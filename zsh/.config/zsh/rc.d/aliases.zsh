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

# Claude Code CLI (if installed)
[ -f "$HOME/.claude/local/claude" ] && alias claude="$HOME/.claude/local/claude"
alias claude-personal='CLAUDE_CONFIG_DIR=~/.claude-personal claude'
alias claude-desktop-personal='open -n -a "Claude" --args --user-data-dir="$HOME/Library/Application Support/Claude-Personal"'

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

# Ollama / local AI
alias ask="ask-ollama -m qwen3.5:latest"
alias quickquestion="ask-ollama -m phi4-mini:latest"


# Searching
alias '?'=duck
alias '??'=google
alias '???'=bing
