# {{{1 Tmux
if [ "$TMUX" = "" ]; then tmux attach || tmux new -s $(hostname) && exit; fi

# {{{1 Completion
autoload -Uz compinit && compinit

# Make completion:
# - Try exact (case-sensitive) match first.
# - Then fall back to case-insensitive.
# - Accept abbreviations after . or _ or - (ie. f.b -> foo.bar).
# - Substring complete (ie. bar -> foobar).
zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}' '+m:{_-}={-_}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Colorize completions using default `ls` colors.
zstyle ':completion:*' list-colors ''

# Allow completion of ..<Tab> to ../ and beyond.
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'

# $CDPATH is overpowered (can allow us to jump to 100s of directories) so tends
# to dominate completion; exclude path-directories from the tag-order so that
# they will only be used as a fallback if no completions are found.
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'

# Categorize completion suggestions with headings:
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format %F{default}%B%{$__WINCENT[ITALIC_ON]%}--- %d ---%{$__WINCENT[ITALIC_OFF]%}%b%f

# Enable keyboard navigation of completions in menu
# (not just tab/shift-tab but cursor keys as well):
zstyle ':completion:*' menu select

# complist must be loaded to use menuselect keymap
zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete   # make Shift-tab go to previous completion

# {{{1 Colors
autoload colors && colors

# {{{1 Prompt
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

# {{{1 Options
setopt AUTO_PARAM_SLASH        # tab completing directory appends a slash
setopt NO_FLOW_CONTROL         # disable start (C-s) and stop (C-q) characters
setopt NO_HIST_IGNORE_ALL_DUPS # don't filter non-contiguous duplicates from history
setopt HIST_FIND_NO_DUPS       # don't show dupes when searching
setopt HIST_IGNORE_DUPS        # do filter contiguous duplicates from history
setopt HIST_VERIFY             # confirm history expansion (!$, !!, !foo)
setopt LIST_PACKED             # make completion lists more densely packed
setopt MENU_COMPLETE           # auto-insert first possible ambiguous completion
setopt PUSHD_IGNORE_DUPS       # don't push multiple copies of same dir onto stack
setopt SHARE_HISTORY           # share history across shells

# {{{1 Word style
# NOTE: must come before zsh-history-substring-search & zsh-syntax-highlighting.
autoload -U select-word-style
select-word-style bash # only alphanumeric chars are considered WORDCHARS

# {{{1 LS colors
export CLICOLOR=1
export LSCOLORS=gafacadabaegedabagacad

# {{{1 Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

# {{{1 ASDF
. /usr/local/opt/asdf/libexec/asdf.sh

# {{{1 NVIM
export EDITOR=vim
export VISUAL="$EDITOR"

# {{{1 Vi mode
set -o vi

# {{{1 Command: c
# Taken from rbates: https://github.com/ryanb/dotfiles/blob/master/oh-my-zsh/custom/plugins/rbates/rbates.plugin.zsh
# Allows you to easily cd into code directory with completion
c() { cd ~/code/$1; }
_c() { _files -W ~/code -/; }
compdef _c c

# {{{1 Path
# Set local path for playlist and other bins
export PATH="./bin":"$PATH":"$HOME/.local/bin"

# {{{1 Edit command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^x' edit-command-line

# {{{1 Plugins
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

# {{{1 Traversing history
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^n' history-substring-search-up
bindkey '^p' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# {{{1 Searching history
bindkey '^r' history-incremental-pattern-search-backward
bindkey "^s" history-incremental-pattern-search-forward

# {{{1 CTRL-Z
# Make CTRL-Z background things and unbackground them.
function fg-bg() {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
  else
    zle push-input
  fi
}
zle -N fg-bg
bindkey '^Z' fg-bg

# {{{1 Aliases
alias git=hub
alias g=git
alias v=vim
alias zshrc="v ~/.zshrc"
alias dot="cd ~/.dotfiles"
alias tmuxconf="v ~/.tmux.conf"
alias vimrc="v ~/.vimrc"
alias be="bundle exec"
alias b="bundle"
alias r="bundle exec rails"
alias gca="g commit -a"
alias gcb="g checkout -b"
alias gco="g checkout"
alias gst="g st"
alias gb="g branch"
