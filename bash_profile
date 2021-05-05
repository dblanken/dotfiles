export BASH_SILENCE_DEPRECATION_WARNING=1
export PATH=$HOME/.bin:$HOME/.local/bin:$PATH:$HOME/.cargo/bin

if [ -e /etc/bashrc ]; then
  source /etc/bashrc
fi

source "$HOME/.shell.d/aliases.bash"
source "$HOME/.shell.d/completion.bash"
source "$HOME/.shell.d/colors.bash"
source "$HOME/.shell.d/dircolors.sh"
source "$HOME/.shell.d/editor.sh"
source "$HOME/.shell.d/history.bash"
source "$HOME/.shell.d/pager.sh"
source "$HOME/.shell.d/prompt.sh"
source "$HOME/.shell.d/settings.bash"
source "$HOME/.shell.d/termcap-colors.sh"
source "$HOME/.shell.d/code.bash"

source /usr/local/opt/asdf/asdf.sh
