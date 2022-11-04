export PATH="$HOME/.local/bin:$PATH"

# General ZSH functions
#
sz() { source ~/.zshrc }

first() { awk '{print $1}' }
second() { awk '{print $2}' }
sum() { paste -sd+ - | bc }

alias u="cd .."
alias cl="clear"
alias l="ls"

alias -g G='| grep'
alias -g L='| less'
alias -g M='| more'
