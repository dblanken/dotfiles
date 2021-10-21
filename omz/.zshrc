export EDITOR='nvim'

# For new dotfiles installs, ohmz might not be there, so let me know
if test ! -d ~/.oh-my-zsh; then
  echo "Don't forget to install oh-my-zsh; exiting"
  return
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="dblanken"

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
ZSH_CUSTOM=~/.config/omz/custom

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  auto-ls-after-cd
  asdf
  bundler
  capistrano
  cd_code
  colored-man-pages
  common-aliases
  ctrlz
  docker
  extract
  git
  github
  gitignore
  history-substring-search
  iterm2
  rails
  rake
  ripgrep
  thefuck
  tmux
  vi-mode
  yarn
  zsh-autosuggestions
  zsh-syntax-highlighting
)

ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_FIXTERM=false
source $ZSH/oh-my-zsh.sh

# User configuration
setopt HIST_IGNORE_SPACE

export GPG_TTY=$(tty)
export KN="$HOME/code"
export GITUSER="dblanken"
export DOTFILES="$HOME/.dotfiles"
export SNIPPETS="$HOME/.local/snippets"

if test "$EDITOR" = "nvim"; then
  if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    if [ -x "$(command -v nvr)" ]; then
      alias nvim=nvr
      export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
    else
      alias nvim='echo "No nesting!"'
    fi
  fi
fi

if test "$EDITOR" != "vim"; then
  alias vim="$EDITOR"
  alias vi="$EDITOR"
  export VISUAL="$EDITOR"
fi

export THOR_MERGE='$EDITOR -d'
export LESSOPEN="|/usr/local/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1

alias mysqld='mysqld --datadir="$DATADIR"'
alias '?'=duck
alias '??'=google
alias '???'=bing
alias lock='pmset displaysleepnow'
alias top='htop'
alias df='df -h'
alias free='free -h'
alias chmox='chmod +x'
alias view='vi -R'
alias clear='printf "\e[H\e[2J"'
alias snippets='cd $SNIPPETS'
alias dot='cd $DOTFILES'
alias x='exit'

export PATH="$HOME/.local/bin:$PATH"
export CDPATH=.:~/code:~
export DATADIR="$HOME/.mysql_data"
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
export SCRIPTS="~/.dotfiles/scripts/.local/bin"

if [ -d "/home/linuxbrew" ]; then
  export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

