export GITUSER="dblanken"
export KN="${HOME}/code"
export LC_ALL=en_US.UTF-8

if [ -e /etc/bashrc ]; then
  source /etc/bashrc
fi

source "$HOME/.shell.rc/detection.sh"
source "$HOME/.shell.rc/path.sh"
source "$HOME/.shell.rc/asdf.sh"
source "$HOME/.shell.rc/aliases.bash"
source "$HOME/.shell.rc/completion.bash"
source "$HOME/.shell.rc/colors.bash"
source "$HOME/.shell.rc/dircolors.sh"
source "$HOME/.shell.rc/editor.sh"
source "$HOME/.shell.rc/history.bash"
source "$HOME/.shell.rc/pager.sh"
source "$HOME/.shell.rc/prompt.sh"
source "$HOME/.shell.rc/settings.bash"
source "$HOME/.shell.rc/termcap-colors.sh"
source "$HOME/.shell.rc/code.bash"
source "$HOME/.shell.rc/bindings.sh"
source "$HOME/.shell.rc/functions.sh"
