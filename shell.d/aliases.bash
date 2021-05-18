unalias -a

# common commands
# Easy searching using lynx
alias '?'='duck'
alias '??'='google'
alias '???'='bing'

alias grep='grep -i --colour=auto'
alias egrep='egrep -i --colour=auto'
alias fgrep='fgrep -i --colour=auto'

alias curl='curl -L'

alias x='exit'
alias dot='cd ~/code/dotfiles'
alias scripts='cd ~/code/dotfiles/scripts'

# overrides
# Have to keep these here due to ~/.bin already being in the path
# Did not want to remove and re-add to beginning
alias irb='irb --readline -r irb/completion'
alias ls='ls -GFh'
alias mkdir='mkdir -p'
