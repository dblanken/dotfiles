# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1"  ] && \
  [ -s "$BASE16_SHELL/profile_helper.sh"  ] && \
  eval "$("$BASE16_SHELL/profile_helper.sh")"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

export GHREPOS="$HOME/code"
export GITUSER="dblanken"

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.local/bin:$HOME/.local/bin/scripts:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/dblanken/.oh-my-zsh"

export ZSH_TMUX_AUTOSTART=true

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git github ripgrep ag common-aliases asdf bundler tmux vi-mode extract gh history-substring-search zsh-autosuggestions zsh-syntax-highlighting yarn)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias killruby='pkill -f ruby'
alias rubykill='killruby'
alias '?'='duck'
alias '??'='google'
alias '???'='bing'
# alias vim='nvim'
# alias irb='bundled_irb --readline -r irb/completion'

# Show contents of directory after cd-ing into it
chpwd() {
  ls -lrthG
}

# Quickly get to my code
c() { cd ~/code/$1; }
_c() { _files -W ~/code -/; }
compdef _c c

rrg() { rails routes | grep "$1" }

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Set 60 fps key repeat rate
#
# Equivalent to the fatest rate acheivable with:
#
#     defaults write NSGlobalDomain KeyRepeat -int 1
#
# But doesn't require a logout and will get restored every time we open a
# shell (for example, if somebody manipulates the slider in the UI).
#
# Fastest rate available from UI corresponds to:
#
#     defaults write NSGlobalDomain KeyRepeat -int 2
#
# Slowest rate available from UI corresponds to:
#
#     defaults write NSGlobalDomain KeyRepeat -int 120
#
# Values at each slider position in UI, from slowest to fastest:
#
# - 120 -> 2 seconds (ie. .5 fps)
# - 90 -> 1.5 seconds (ie .6666 fps)
# - 60 -> 1 second (ie 1 fps)
# - 30 -> 0.5 seconds (ie. 2 fps)
# - 12 -> 0.2 seconds (ie. 5 fps)
# - 6 -> 0.1 seconds (ie. 10 fps)
# - 2 -> 0.03333 seconds (ie. 30 fps)
#
# See: https://github.com/mathiasbynens/dotfiles/issues/687
#
if command -v dry &> /dev/null; then
  dry 0.0166666666667 > /dev/null
fi

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!{.git,node_modules,coverage}/*"'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi
