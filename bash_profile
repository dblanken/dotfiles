export GITUSER="dblanken"
export KN="${HOME}/code"

if [ -e /etc/bashrc ]; then
  source /etc/bashrc
fi

source "$HOME/.shell.d/detection.sh"
source "$HOME/.shell.d/asdf.sh"
source "$HOME/.shell.d/aliases.bash"
source "$HOME/.shell.d/path.sh"
source "$HOME/.shell.d/completion.bash"
source "$HOME/.shell.d/colors.bash"
source "$HOME/.shell.d/dircolors.sh"
source "$HOME/.shell.d/editor.sh"
source "$HOME/.shell.d/history.bash"
source "$HOME/.shell.d/pager.sh"
source "$HOME/.shell.d/path.sh"
source "$HOME/.shell.d/prompt.sh"
source "$HOME/.shell.d/settings.bash"
source "$HOME/.shell.d/termcap-colors.sh"
source "$HOME/.shell.d/code.bash"
source "$HOME/.shell.d/bindings.sh"
source "$HOME/.shell.d/functions.sh"
