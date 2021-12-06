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
