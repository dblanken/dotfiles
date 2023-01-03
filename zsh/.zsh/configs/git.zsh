compdef g=git
function g {
	if [[ $# -gt 0 ]]; then
		git "$@"
	else
		git status --short --branch
	fi
}

# Taken and modified from https://github.com/wincent/wincent/blob/main/aspects/dotfiles/files/.zshrc
# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "%F{green}●%f" # default 'S'
zstyle ':vcs_info:*' unstagedstr "%F{red}●%f" # default 'U'
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:git+set-message:*' hooks git-untracked
zstyle ':vcs_info:git*:*' formats '[%F{cyan}%b%f%m%c%u] ' # default ' (%s)-[%b]%c%u-'
zstyle ':vcs_info:git*:*' actionformats '[%F{cyan}%b%f|%a%m%c%u] ' # default ' (%s)-[%b|%a]%c%u-'

function +vi-git-untracked() {
  emulate -L zsh
  if [[ -n $(git ls-files --exclude-standard --others 2> /dev/null) ]]; then
    hook_com[unstaged]+="%F{blue}●%f"
  fi
}

precmd() {
  vcs_info
}

export PROMPT=$'%{$fg[yellow]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%} %{$fg[blue]%}%1~%{$reset_color%}${vcs_info_msg_0_} %# '
export SPROMPT="zsh: correct %F{red}'%R'%f to %F{red}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "

alias gca='git commit -a'
alias gcb='git checkout -b'
alias gco='git checkout'
alias gst='git status'
alias gb='git branch'
alias gad='git add .'
alias gp='git push'
alias gd='git diff'
alias gl='git log'
alias glog='git log --oneline --decorate --graph'
