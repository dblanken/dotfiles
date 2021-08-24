export XDG_CONFIG_HOME=$HOME/.config/
export EDITOR='nvim'
export PATH="$HOME/.local/bin:$PATH"
export ZSH_TMUX_AUTOSTART=true

setopt functionargzero
setopt hist_ignore_space

autoload -Uz bashcompinit && bashcompinit
autoload -Uz compinit && compinit

source $XDG_CONFIG_HOME/antigen/dblanken.plugin.zsh
source $XDG_CONFIG_HOME/antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle 'zsh-users/zsh-syntax-highlighting'
antigen bundle 'zsh-users/zsh-autosuggestions'
antigen bundle git
antigen bundle tmux
antigen bundle asdf
antigen theme denysdovhan/spaceship-prompt

antigen apply
