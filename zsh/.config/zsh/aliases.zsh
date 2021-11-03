# Handle the fact that this file will be used with multiple OSs
platform=`uname`
if [[ $platform == 'Linux' ]]; then
  alias a='ls -lrth --color'
elif [[ $platform == 'Darwin' ]]; then
  alias a='ls -lrthG'
fi

alias -g G='| grep'
alias -g L='| less'
alias -g M='| more'
alias aliases='vim ~/.config/zsh/aliases.zsh'
alias amend="git commit --amend"
alias b='bin/rspec'
alias bdp='production deploy'
alias bds='staging deploy'
alias be='bundle exec'
alias bi='bundle install'
alias bu='bundle update'
alias bunbang='bundle install && !!'
alias c='cd'
alias cat='bat'
alias code='cd ~/code'
alias d='cd ~/.dotfiles'
alias fs='bundle install && foreman start'
alias gad='git add --all .'
alias gag='git add . && git commit --amend --no-edit && git push -f'
alias gca='git commit -a'
alias gcaa='git commit -a --amend -C HEAD'
alias gcl='git clone'
alias gcm="git commit -m"
alias gco='git checkout'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdm='git diff master'
alias gg='git lg'
alias gp='git push'
alias gpf='git push --force'
alias gpr='git pull --rebase'
alias gpush='echo "Use gp!" && git push'
alias grc='git rebase --continue'
alias gs='git show'
alias h='sync'
alias hpr='hub pull-request'
alias irb='irb --readline -r irb/completion'
alias killruby='pkill -f ruby'
alias rubykill='killruby'
alias m='git checkout master'
alias squash='git rebase -i master'
alias newscreen="tmux"
alias rc='bin/rails console'
alias rdm="bin/rails db:migrate"
alias rdtp="bin/rails db:test:prepare"
alias reattach='tmux attach'
alias reguard='killall -9 ruby ; guard'
alias remigrate='rails db:migrate && rails db:migrate:redo && rails db:schema:dump && rails db:test:prepare'
alias remore='!! | more'
alias repush="gpr && git push"
alias rerake='!! && rake'
alias rerails='!! && rails'
alias retag='ctags -R --exclude=node_modules --exclude=.svn --exclude=.git --exclude=log --exclude=tmp *'
alias rs='bundle check && rails server -p 3000'
alias safepush='git pull --rebase && bundle install && rdm && rake && git push'
alias shametest='RUBYOPT="-W0" rails test'
alias so='source ~/.config/zsh/aliases.zsh'
alias sp='safepush'
alias squash='git rebase -i master'
alias ss='spring stop'
alias sync='git add -u . && git commit -m "Minor changes. Commit message skipped." && repush'
alias track='git checkout -t'
alias trs='tmux rename-session'
alias u='cd ..'
alias undeployed='git fetch --multiple production origin && git log production/master..origin/master'
alias v='vim'
alias vi='vim'
alias ys='yarn serve'
alias yw='yarn watch'