# Allow completing of the remainder of a command
bindkey "^N" insert-last-word

# Show contents of directory after cd-ing into it
chpwd() {
  ls -lrthG
}

# Save a ton of history
HISTSIZE=20000
HISTFILE=~/.zsh_history
SAVEHIST=20000

# Enable completion
autoload -U compinit
compinit

# Disable flow control commands (keeps C-s from freezing everything)
stty start undef
stty stop undef

# Sourcing of other files
source $HOME/.config/zsh/aliases.zsh
source $HOME/.config/zsh/functions.zsh
source $HOME/.config/zsh/prompt.zsh
source $HOME/.config/zsh/z.zsh

# Add current directory bin
export PATH=$PATH:bin

# Add my own bin
export PATH=$PATH:$HOME/.local/bin

# Add homebrew's bin
export PATH=$PATH:/usr/local/bin

# Update hombrew once a week
export HOMEBREW_AUTO_UPDATE_SECS=600000

# Source ASDF
source ~/.asdf/asdf.sh
